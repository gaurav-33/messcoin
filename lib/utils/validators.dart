class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 70) {
      return 'Name must be at most 70 characters';
    }
    return null;
  }

  static String? validateRollNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Roll number is required';
    }
    if (value.trim().length > 15) {
      return 'Roll number must be at most 15 characters';
    }
    if (!RegExp(r'^[0-9]{6,15}?$').hasMatch(value.trim())) {
      return 'Enter a valid roll number';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w\.-]+@nitp\.ac\.in?$').hasMatch(value.trim())) {
      return 'Enter a valid @nitp.ac.in email address';
    }
    return null;
  }

  static String? validateAllEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateRoomNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Room number is required';
    }
    if (value.trim().length > 10) {
      return 'Room number must be at most 10 characters';
    }
    return null;
  }

  static String? validateSemester(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Semester is required';
    }
    if (int.tryParse(value.trim()) == null || int.parse(value.trim()) < 1) {
      return 'Enter a valid semester';
    }
    if (value.trim().length > 2) {
      return 'Semester must be at most 2 digits';
    }
    return null;
  }

  static String? validateHostel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Hostel is required';
    }
    return null;
  }

  static String? validateMess(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mess is required';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }
    if (value.trim().length != 6 ||
        !RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit OTP';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return 'Enter a valid amount greater than 0';
    }
    if (amount > 6000) {
      return 'Amount must be less than or equal to 6000';
    }
    return null;
  }

  static validateFeedback(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Feedback is required';
    }
    if (value.length > 500) {
      return 'Feedback length should be less than 500';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone No. is required';
    }
    if (value.length != 10) {
      return 'Enter a valid 10 digit phone number';
    }
    if (RegExp(r'^[0-5]').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }
}
