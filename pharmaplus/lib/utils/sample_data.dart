import '../models/product.dart';

class SampleData {
  static List<Product> getInitialProducts() {
    return [
      Product(
        id: '1',
        name: 'Paracetamol 500mg',
        price: 5.99,
        image: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
        description: 'জ্বর এবং ব্যথা নিরাময়ের জন্য কার্যকর ঔষধ',
        stock: 150,
        category: 'Pain Relief',
        dosage: '৫০০মিগ্রা - প্রতি ৪-৬ ঘণ্টায় ১-২ টি ট্যাবলেট',
        prescriptionRequired: false,
        manufacturer: 'HealthCare Pharma',
      ),
      Product(
        id: '2',
        name: 'Vitamin D3 1000 IU',
        price: 12.99,
        image: 'https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=400',
        description: 'হাড়ের স্বাস্থ্য এবং রোগ প্রতিরোধ ক্ষমতার জন্য জরুরি ভিটামিন',
        stock: 80,
        category: 'Vitamins',
        dosage: '১০০০ IU - দৈনিক ১টি ক্যাপসুল',
        prescriptionRequired: false,
        manufacturer: 'VitaHealth',
      ),
      Product(
        id: '3',
        name: 'Amoxicillin 250mg',
        price: 18.99,
        image: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=400',
        description: 'ব্যাকটেরিয়া সংক্রমণের জন্য অ্যান্টিবায়োটিক',
        stock: 45,
        category: 'Antibiotics',
        dosage: '২৫০মিগ্রা - দৈনিক ৩ বার',
        prescriptionRequired: true,
        manufacturer: 'MediCore Labs',
      ),
    ];
  }
}