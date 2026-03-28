import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'package:usta_app/data/models/payment_model.dart';
import 'package:usta_app/domain/entities/entities.dart';
import 'package:usta_app/presentation/blocs/blocs.dart';
import 'package:usta_app/presentation/widgets/gradient_button.dart';
import 'package:usta_app/presentation/screens/map/location_picker_screen.dart';
import 'widgets/order_form_widgets.dart';

class CreateOrderScreen extends StatefulWidget {
  final ServiceEntity service;
  const CreateOrderScreen({super.key, required this.service});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  PaymentMethod _selectedPayment = PaymentMethod.card;
  LatLng? _pickedLatLng;

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _pickLocationOnMap() async {
    final result = await Navigator.of(context).push<LocationResult>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(initialLocation: _pickedLatLng),
      ),
    );
    if (result != null) {
      setState(() {
        _pickedLatLng = result.latLng;
        _addressController.text = result.address;
      });
    }
  }

  void _confirmOrder() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    final user = authState.user;

    final scheduled = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final order = OrderEntity(
      id: '',
      clientId: user.id,
      clientName: user.name,
      clientAvatarUrl: user.avatarUrl,
      workerId: widget.service.workerId,
      workerName: widget.service.workerName,
      workerAvatarUrl: widget.service.workerAvatarUrl,
      serviceId: widget.service.id,
      serviceName: widget.service.name,
      serviceCategory: widget.service.category,
      amount: widget.service.price,
      status: OrderStatus.pending,
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
      chatId: '',
      scheduledAt: scheduled,
      createdAt: DateTime.now(),
    );

    context.read<OrderBloc>().add(OrderCreate(order));
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тапсырыс беру')),
      body: BlocListener<OrderBloc, OrderState>(
        listener: _handleOrderState,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildServiceSummary(),
              const SizedBox(height: 24),
              _buildScheduleSection(context),
              const SizedBox(height: 24),
              _buildLocationSection(context),
              const SizedBox(height: 24),
              _buildNotesSection(context),
              const SizedBox(height: 24),
              _buildPaymentSection(context),
              const SizedBox(height: 32),
              _buildPriceBreakdown(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Event listener ────────────────────────────────────────────────────────

  void _handleOrderState(BuildContext context, OrderState state) {
    if (state is OrderCreated) {
      context.go(AppRouter.orders);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Тапсырыс орналастырылды! 🎉'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (state is OrderError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─── Section builders ──────────────────────────────────────────────────────

  Widget _buildServiceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.handyman_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.service.workerName} арқылы',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.service.formattedPrice,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Кесте', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DateTimePickerCard(
                icon: Icons.calendar_month_rounded,
                label: 'Күн',
                value: DateFormat('MMM dd, yyyy').format(_selectedDate),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DateTimePickerCard(
                icon: Icons.access_time_rounded,
                label: 'Уақыт',
                value: _selectedTime.format(context),
                onTap: _pickTime,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Орналасуы', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            hintText: 'Мекенжайды енгізіңіз',
            prefixIcon: const Icon(Icons.location_on_outlined),
            suffixIcon: Tooltip(
              message: 'Картадан таңдау',
              child: IconButton(
                icon: const Icon(Icons.map_rounded, color: AppColors.primary),
                onPressed: _pickLocationOnMap,
              ),
            ),
          ),
          maxLines: 2,
        ),
        if (_pickedLatLng != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                'Координаттар: ${_pickedLatLng!.latitude.toStringAsFixed(5)}, '
                '${_pickedLatLng!.longitude.toStringAsFixed(5)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ескертпелер (міндетті емес)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Арнайы талаптар...',
            prefixIcon: Icon(Icons.note_outlined),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Төлем әдісі', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        PaymentSelector(
          selected: _selectedPayment,
          onChanged: (m) => setState(() => _selectedPayment = m),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    final serviceFee = widget.service.price * 0.05;
    final total = widget.service.price + serviceFee;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          PriceRow(
            label: 'Қызмет бағасы',
            value: '\$${widget.service.price.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          PriceRow(
            label: 'Қызмет ақысы (5%)',
            value: '\$${serviceFee.toStringAsFixed(2)}',
          ),
          const Divider(height: 20),
          PriceRow(
            label: 'Жиыны',
            value: '\$${total.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) => GradientButton(
        onPressed: state is OrderLoading ? null : _confirmOrder,
        isLoading: state is OrderLoading,
        label: 'Тапсырысты растау',
        icon: Icons.check_circle_rounded,
      ),
    );
  }
}
