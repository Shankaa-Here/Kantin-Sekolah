import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const KantinApp());

// --- DATA MODEL ---
class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  int stock;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, required this.quantity});
}

// --- STATE MANAGER SEDERHANA ---
class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> items = [];

  double get totalPrice {
    double total = 0;
    for (var cartItem in items) {
      total += cartItem.item.price * cartItem.quantity;
    }
    return total;
  }

  void addToCart(MenuItem item, int quantity) {
    final existingIndex = items.indexWhere((ci) => ci.item.id == item.id);
    if (existingIndex >= 0) {
      items[existingIndex].quantity += quantity;
    } else {
      items.add(CartItem(item: item, quantity: quantity));
    }
  }

  void clearCart() {
    items.clear();
  }
}

// Data menu kantin diperbanyak
final List<MenuItem> menuData = [
  MenuItem(id: 1, name: 'Mi Ayam Spesial', description: 'Mi kenyal dengan ayam kecap gurih dan pangsit.', price: 12000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 15),
  MenuItem(id: 2, name: 'Batagor Kuah', description: 'Bakso tahu goreng renyah dengan bumbu kacang khas.', price: 10000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 10),
  MenuItem(id: 3, name: 'Es Teh Manis', description: 'Es teh segar penghilang dahaga di siang hari.', price: 3000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 30),
  MenuItem(id: 4, name: 'Nasi Goreng Kantin', description: 'Nasi goreng spesial bumbu rempah dengan telur.', price: 15000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 8),
  MenuItem(id: 5, name: 'Siomay Ikan', description: 'Siomay ikan tenggiri asli dengan saus kacang pedas.', price: 8000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 12),
  MenuItem(id: 6, name: 'Soto Ayam Hangat', description: 'Soto kuah kuning gurih dengan suwiran ayam dan suun.', price: 13000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 14),
  MenuItem(id: 7, name: 'Nasi Uduk Komplit', description: 'Nasi uduk gurih lengkap dengan tempe, bihun, dan telur.', price: 10000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 20),
  MenuItem(id: 8, name: 'Es Jeruk Segar', description: 'Perasan jeruk murni asli dengan es batu segar.', price: 4000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 25),
  MenuItem(id: 9, name: 'Kentang Goreng', description: 'Camilan kentang goreng renyah dengan taburan bumbu.', price: 9000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 15),
  MenuItem(id: 10, name: 'Pisang Goreng Keju', description: 'Pisang manis berbalut tepung renyah dengan keju parut.', price: 6000, imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', stock: 18),
];

// --- APP ENTRY ---
class KantinApp extends StatelessWidget {
  const KantinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin ICB Cinta Teknika',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

// --- HOME PAGE ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MenuItem> _filteredMenu = menuData;

  void _filterMenu(String query) {
    setState(() {
      _filteredMenu = menuData
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kantin ICB Cinta Teknika', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 28),
                if (CartManager().items.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text(
                        '${CartManager().items.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()))
                  .then((_) => setState(() {}));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(backgroundColor: Colors.white, radius: 28, child: Icon(Icons.store, size: 32, color: Colors.blue)),
                  SizedBox(height: 8),
                  Text('Kantin ICB Cinta Teknika', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Sehat, Bersih, & Berkualitas', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Colors.blue),
              title: const Text('Katalog Menu'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: Colors.blue),
              title: const Text('Keranjang Belanja'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()))
                    .then((_) => setState(() {}));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('Tentang Kantin'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Datang di Kantin ICB 👋', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Pilih jajanan favoritmu dan nikmati harimu!', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari makanan atau minuman...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.blue.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: _filterMenu,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredMenu.isEmpty
                ? const Center(child: Text('Menu tidak ditemukan.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: _filteredMenu.length,
                    itemBuilder: (context, index) {
                      final item = _filteredMenu[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DetailPage(item: item)),
                              ).then((_) => setState(() {}));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(item.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text('Rp ${item.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.inventory_2_outlined, size: 14, color: item.stock > 0 ? Colors.green : Colors.red),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.stock > 0 ? 'Stok: ${item.stock}' : 'Habis',
                                              style: TextStyle(fontSize: 12, color: item.stock > 0 ? Colors.green[700] : Colors.red, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- DETAIL PAGE ---
class DetailPage extends StatefulWidget {
  final MenuItem item;
  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.item.imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(widget.item.name, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        'Rp ${widget.item.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 16, color: widget.item.stock > 0 ? Colors.green : Colors.red),
                      const SizedBox(width: 6),
                      Text(
                        widget.item.stock > 0 ? 'Sisa Stok: ${widget.item.stock}' : 'Stok Habis',
                        style: TextStyle(color: widget.item.stock > 0 ? Colors.green[700] : Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  // Diperbaiki menggunakan Colors.black87
                  Text(widget.item.description, style: const TextStyle(color: Colors.black87, height: 1.4)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jumlah Porsi:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                if (_quantity > 1) _quantity--;
                              });
                            },
                          ),
                          Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                if (_quantity < widget.item.stock) {
                                  _quantity++;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Jumlah melebihi stok tersedia!')),
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Harga:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        'Rp ${(widget.item.price * _quantity).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.item.stock > 0 ? Colors.blue : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.shopping_cart_rounded),
                      label: Text(widget.item.stock > 0 ? 'Tambah ke Keranjang' : 'Stok Habis', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: widget.item.stock > 0
                          ? () {
                              CartManager().addToCart(widget.item, _quantity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Berhasil menambahkan $_quantity porsi ${widget.item.name} ke keranjang!')),
                              );
                              Navigator.pop(context);
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CART PAGE ---
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager().items;

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text('Keranjang Belanja Kamu Kosong', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Yuk pilih menu favoritmu di katalog!', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Lihat Menu'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(cartItem.item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          title: Text(cartItem.item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Rp ${cartItem.item.price} x ${cartItem.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rp ${cartItem.item.price * cartItem.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    cartItems.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Pembayaran:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Rp ${CartManager().totalPrice}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CheckoutPage()),
                            ).then((_) => setState(() {}));
                          },
                          child: const Text('Lanjut ke Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// --- CHECKOUT PAGE (SISTEM PEMBAYARAN) ---
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'Tunai di Kantin';

  void _processPayment() {
    for (var cartItem in CartManager().items) {
      cartItem.item.stock -= cartItem.quantity;
      if (cartItem.item.stock < 0) cartItem.item.stock = 0;
    }

    CartManager().clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Pesanan Berhasil!'),
          ],
        ),
        content: Text('Pesananmu berhasil dibuat di Kantin ICB Cinta Teknika.\nMetode: $_selectedPaymentMethod'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout & Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ringkasan Tagihan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Belanja:', style: TextStyle(fontSize: 16)),
                    Text('Rp ${CartManager().totalPrice}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pilih Metode Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            RadioListTile<String>(
              title: const Text('Tunai di Kantin (Bayar saat ambil)'),
              value: 'Tunai di Kantin',
              groupValue: _selectedPaymentMethod,
              onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
            ),
            RadioListTile<String>(
              title: const Text('QRIS / Scan Barcode Kantin'),
              value: 'QRIS',
              groupValue: _selectedPaymentMethod,
              onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
            ),
            RadioListTile<String>(
              title: const Text('Saldo Digital Siswa'),
              value: 'Saldo Digital',
              groupValue: _selectedPaymentMethod,
              onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _processPayment,
                child: const Text('Konfirmasi Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ABOUT PAGE ---
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Kantin')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(radius: 40, backgroundColor: Colors.blue, child: Icon(Icons.storefront, size: 50, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text('Kantin ICB Cinta Teknika', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Pusat Kuliner Sehat & Higienis Sekolah', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Divider(height: 40),
            const Text('Jam Operasional:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('Senin - Jumat: 07.00 - 15.00 WIB'),
            const SizedBox(height: 16),
            const Text('Lokasi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('Area Gedung Utama Sekolah, Samping Ruang serbaguna ICB.'),
          ],
        ),
      ),
    );
  }
}
