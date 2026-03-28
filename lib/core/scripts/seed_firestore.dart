// 🌱 Firestore Seed Script
// Run ONCE to populate the database with demo services and workers.
// Call SeedFirestore.run() from any screen's initState (then remove the call).

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeedFirestore {
  SeedFirestore._();

  static final _db = FirebaseFirestore.instance;

  static Future<void> run() async {
    debugPrint('[Seed] Starting Firestore seed...');
    final workerIds = await _seedWorkers();
    await _seedServices(workerIds);
    debugPrint('[Seed] ✅ Done! Database populated successfully.');
  }

  // ─── Workers ──────────────────────────────────────────────────────────────

  static Future<List<String>> _seedWorkers() async {
    final workers = [
      {
        'name': 'Ахмет Жақсыбеков',
        'email': 'ahmet@test.com',
        'phone': '+77011112233',
        'role': 'worker',
        'avatarUrl': null,
        'rating': 4.9,
        'reviewCount': 34,
        'isVerified': true,
        'bio':
            'Профессиональный сантехник с 10-летним опытом. Работаю быстро и чисто.',
        'serviceCategories': ['Plumbing', 'Repair'],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'name': 'Дина Сейткали',
        'email': 'dina@test.com',
        'phone': '+77022223344',
        'role': 'worker',
        'avatarUrl': null,
        'rating': 4.8,
        'reviewCount': 21,
        'isVerified': true,
        'bio':
            'Специалист по уборке квартир и офисов. Использую безопасную химию.',
        'serviceCategories': ['Cleaning'],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'name': 'Максат Ермеков',
        'email': 'maksat@test.com',
        'phone': '+77033334455',
        'role': 'worker',
        'avatarUrl': null,
        'rating': 4.7,
        'reviewCount': 15,
        'isVerified': true,
        'bio': 'Учитель математики и физики для 5–11 классов. Готовлю к ЕНТ.',
        'serviceCategories': ['Tutoring'],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'name': 'Арман Бекешев',
        'email': 'arman@test.com',
        'phone': '+77044445566',
        'role': 'worker',
        'avatarUrl': null,
        'rating': 4.6,
        'reviewCount': 28,
        'isVerified': true,
        'bio':
            'Электрик 4-го разряда. Провожу проводку, монтаж розеток и светильников.',
        'serviceCategories': ['Repair'],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'name': 'Айгерим Нурланова',
        'email': 'aigerim@test.com',
        'phone': '+77055556677',
        'role': 'worker',
        'avatarUrl': null,
        'rating': 5.0,
        'reviewCount': 44,
        'isVerified': true,
        'bio':
            'Мастер маникюра и педикюра. Выезжаю на дом. Портфолио в Instagram.',
        'serviceCategories': ['Beauty'],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    final ids = <String>[];
    for (final worker in workers) {
      final doc = await _db.collection('users').add(worker);
      ids.add(doc.id);
      debugPrint('[Seed] Worker: ${worker['name']} → ${doc.id}');
    }
    return ids;
  }

  // ─── Services ─────────────────────────────────────────────────────────────
  // workerIds: [0]=Ахмет, [1]=Дина, [2]=Максат, [3]=Арман, [4]=Айгерим

  static Future<void> _seedServices(List<String> ids) async {
    final services = [
      // Plumbing
      _service(
        'Ремонт смесителей и кранов',
        'Устранение протечек, замена уплотнителей, ремонт или замена смесителей. Приезжаю со своими инструментами.',
        'Plumbing',
        5000.0,
        'fixed',
        'https://images.unsplash.com/photo-1585704032915-c3400305e979?w=600&auto=format',
        4.9,
        18,
        ids[0],
        'Ахмет Жақсыбеков',
        ['сантехника', 'кран', 'протечка'],
      ),
      _service(
        'Установка унитаза и раковины',
        'Профессиональная установка сантехники под ключ. Помогу выбрать подходящую модель.',
        'Plumbing',
        12000.0,
        'fixed',
        'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=600&auto=format',
        4.8,
        11,
        ids[0],
        'Ахмет Жақсыбеков',
        ['сантехника', 'унитаз', 'установка'],
      ),

      // Cleaning
      _service(
        'Генеральная уборка квартиры',
        'Полная уборка: мытьё окон, плинтусов, сантехники, холодильника и духовки. Всё включено.',
        'Cleaning',
        15000.0,
        'fixed',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&auto=format',
        4.9,
        12,
        ids[1],
        'Дина Сейткали',
        ['уборка', 'чистота', 'генеральная'],
      ),
      _service(
        'Поддерживающая уборка (2–3 часа)',
        'Быстрая уборка кухни, ванной и жилых комнат. Пылесос, моп, протирка поверхностей.',
        'Cleaning',
        6000.0,
        'hourly',
        'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=600&auto=format',
        4.7,
        9,
        ids[1],
        'Дина Сейткали',
        ['уборка', 'быстро', 'домашняя'],
      ),

      // Tutoring
      _service(
        'Репетитор по математике (ЕНТ)',
        'Готовлю школьников к ЕНТ по математике. Разбираем все темы с нуля, решаем пробные варианты.',
        'Tutoring',
        3500.0,
        'hourly',
        'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=600&auto=format',
        4.7,
        15,
        ids[2],
        'Максат Ермеков',
        ['математика', 'ент', 'репетитор'],
      ),

      // Repair
      _service(
        'Электрическая проводка под ключ',
        'Монтаж и замена электропроводки. Установка розеток, выключателей, щитков.',
        'Repair',
        800.0,
        'hourly',
        'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600&auto=format',
        4.6,
        22,
        ids[3],
        'Арман Бекешев',
        ['электрик', 'проводка', 'розетки'],
      ),
      _service(
        'Установка люстры и светильников',
        'Быстрая установка люстр, бра, точечных светильников. Высотные работы в том числе.',
        'Repair',
        4000.0,
        'fixed',
        'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?w=600&auto=format',
        4.8,
        6,
        ids[3],
        'Арман Бекешев',
        ['электрик', 'люстра', 'освещение'],
      ),

      // Beauty
      _service(
        'Гель-лак маникюр (выезд на дом)',
        'Профессиональный маникюр с покрытием гель-лаком. Большая палитра цветов. Выезжаю в любой район.',
        'Beauty',
        8000.0,
        'fixed',
        'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=600&auto=format',
        5.0,
        44,
        ids[4],
        'Айгерим Нурланова',
        ['маникюр', 'гель', 'красота'],
      ),
      _service(
        'Педикюр + уход за стопами',
        'Классический педикюр с обработкой кожи и покрытием гель-лаком. Гигиенически и аккуратно.',
        'Beauty',
        9000.0,
        'fixed',
        'https://images.unsplash.com/photo-1519751138087-5bf79df62d5b?w=600&auto=format',
        4.9,
        31,
        ids[4],
        'Айгерим Нурланова',
        ['педикюр', 'уход', 'красота'],
      ),
    ];

    for (final service in services) {
      final doc = await _db.collection('services').add(service);
      debugPrint('[Seed] Service: ${service['name']} → ${doc.id}');
    }
  }

  /// Helper to build a service map without repetition
  static Map<String, dynamic> _service(
    String name,
    String description,
    String category,
    double price,
    String priceType,
    String imageUrl,
    double rating,
    int reviewCount,
    String workerId,
    String workerName,
    List<String> tags,
  ) => {
    'name': name,
    'description': description,
    'category': category,
    'price': price,
    'priceType': priceType,
    'imageUrl': imageUrl,
    'rating': rating,
    'reviewCount': reviewCount,
    'workerId': workerId,
    'workerName': workerName,
    'workerAvatarUrl': null,
    'isActive': true,
    'tags': tags,
    'city': 'Астана',
    'createdAt': Timestamp.now(),
  };
}
