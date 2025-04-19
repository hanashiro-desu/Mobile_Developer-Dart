import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for DateFormat

class FormBasicDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormBasicDemoState();
}

class _FormBasicDemoState extends State<FormBasicDemo> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController(); // Controller for Date of Birth
  DateTime? _dateOfBirth; // Store the selected date of birth

  bool _obscurePassword = true;
  String? _selectedCity;
  String? _gender;
  bool _isAgreed = false;

  final List<String> _cities = [
    'Hà Nội',
    'TP.HCM',
    'Đà Nẵng',
    'Cần Thơ',
    'Hải Phòng',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form cơ bản")),
      body: Padding( // Outer padding
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Add SingleChildScrollView here
            child: Column(
              children: [
                TextFormField(
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    labelText: "Họ và tên",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Date of Birth Field
                TextFormField(
                  controller: _dateOfBirthController,
                  decoration: InputDecoration(
                    labelText: 'Ngày sinh',
                    hintText: 'Chọn ngày sinh của bạn',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Make it read-only so users can only select via the date picker
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2025),
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                      setState(() {
                        _dateOfBirthController.text = formattedDate;
                        _dateOfBirth = pickedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn ngày sinh';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                Text("Giới tính", style: TextStyle(fontWeight: FontWeight.bold)),
                RadioListTile<String>(
                  title: Text('Nam'),
                  value: 'male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Nữ'),
                  value: 'female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    }
                    if (value != _passwordController.text) {
                      return 'Mật khẩu không khớp';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Thành phố",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCity,
                  items: _cities.map((city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn thành phố';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text("Đồng ý với điều khoản của công ty"),
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  },
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _isAgreed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Đăng ký thành công!")),
                          );
                        } else if (!_isAgreed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Bạn cần đồng ý với điều khoản")),
                          );
                        }
                      },
                      child: Text("Submit"),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                        setState(() {
                          _isAgreed = false;
                          _dateOfBirthController.clear(); // Clear the date of birth field on reset
                          _dateOfBirth = null; // Reset the date of birth value
                          _gender = null; //Reset the gender field on reset
                          _selectedCity = null;//Reset the selected city field on reset
                        });
                      },
                      child: Text("Reset"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}