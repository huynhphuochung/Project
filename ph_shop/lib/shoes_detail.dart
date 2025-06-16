import 'package:flutter/material.dart';
import 'shoes.dart';

class ShoesDetail extends StatefulWidget {
  final Shoes shoes;
  const ShoesDetail({Key? key, required this.shoes}) : super(key: key);
  @override
  State<ShoesDetail> createState() {
    return _ShoesDetailState();
  }
}

class _ShoesDetailState extends State<ShoesDetail> {
  late Information_shoes _infoShoes;
  int _selectedSize=0;
  @override
  void initState() {
    super.initState();
    _infoShoes = Information_shoes.List_Information_shoes.firstWhere(
      (info) => info.id == widget.shoes.id,
    );
    _selectedSize = 0;
  }

  // TODO: Add _sliderVal here
  @override
  Widget build(BuildContext context) {
    // 1
    return Scaffold(
      appBar: AppBar(title: Text(widget.shoes.name)),
      // 2
      body: SafeArea(
        // 3
        child: Column(
          children: <Widget>[
            // 4
            SizedBox(
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage(widget.shoes.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 5
            const SizedBox(height: 5),
            // 6
            Text(
              widget.shoes.name,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'MerriweatherSans',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Gía:${widget.shoes.price}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
           
           
            const SizedBox(height: 5),
             Text(
              'Kích cỡ: ${_infoShoes.size[_selectedSize]}',
              style: const TextStyle(fontSize: 16),
            ),
             const SizedBox(height: 5),
            
            Wrap(
              spacing: 8.0,
              children: List.generate(
                _infoShoes.size.length,
                (index) => ChoiceChip(
                  label: Text(_infoShoes.size[index].toInt().toString()),
                  selected: _selectedSize == index,
                  selectedColor: Colors.orange[100], // Màu nền khi chọn
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color:
                          _selectedSize == index ? Colors.orange : Colors.grey,
                      width: 1,
                    ),
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedSize = selected ? index : _selectedSize;
                    });
                  },
                ),
              ),
            ),
             const SizedBox(height: 5),
            Text(
              'Mô tả: ${_infoShoes.describe}',
              style: const TextStyle(fontSize: 16),
            ),
            // TODO: Add Expanded

            // TODO: Add Slider() here
          ],
        ),
      ),
    );
  }
}
