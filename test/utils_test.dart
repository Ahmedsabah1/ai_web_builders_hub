import 'package:flutter_test/flutter_test.dart';
import 'package:ai_web_builders_hub/core/utils/app_utils.dart';

void main() {
  group('AppUtils Tests', () {
    group('Email Validation', () {
      test('should return true for valid email', () {
        expect(AppUtils.isValidEmail('test@example.com'), true);
        expect(AppUtils.isValidEmail('user.name@domain.co.uk'), true);
        expect(AppUtils.isValidEmail('user+tag@example.org'), true);
      });

      test('should return false for invalid email', () {
        expect(AppUtils.isValidEmail('invalid-email'), false);
        expect(AppUtils.isValidEmail('test@'), false);
        expect(AppUtils.isValidEmail('@example.com'), false);
        expect(AppUtils.isValidEmail(''), false);
      });
    });

    group('Password Validation', () {
      test('should return null for valid password', () {
        expect(AppUtils.validatePassword('password123'), null);
        expect(AppUtils.validatePassword('secure_password'), null);
      });

      test('should return error for invalid password', () {
        expect(AppUtils.validatePassword(''), 'Password is required');
        expect(AppUtils.validatePassword('123'), 'Password must be at least 6 characters');
        expect(AppUtils.validatePassword('a' * 101), 'Password must be less than 100 characters');
      });
    });

    group('URL Validation', () {
      test('should return true for valid URLs', () {
        expect(AppUtils.isValidUrl('https://example.com'), true);
        expect(AppUtils.isValidUrl('http://test.org'), true);
        expect(AppUtils.isValidUrl('https://sub.domain.com/path?query=1'), true);
      });

      test('should return false for invalid URLs', () {
        expect(AppUtils.isValidUrl('not-a-url'), false);
        expect(AppUtils.isValidUrl('ftp://example.com'), false);
        expect(AppUtils.isValidUrl(''), false);
      });
    });

    group('Text Utilities', () {
      test('should truncate text correctly', () {
        expect(AppUtils.truncateText('Hello World', 5), 'Hello...');
        expect(AppUtils.truncateText('Short', 10), 'Short');
        expect(AppUtils.truncateText('', 5), '');
      });

      test('should format rating correctly', () {
        expect(AppUtils.formatRating(4.5), '4.5');
        expect(AppUtils.formatRating(3.0), '3.0');
        expect(AppUtils.formatRating(4.567), '4.6');
      });
    });

    group('Domain Extraction', () {
      test('should extract domain from URL', () {
        expect(AppUtils.getDomainFromUrl('https://example.com/path'), 'example.com');
        expect(AppUtils.getDomainFromUrl('http://sub.domain.org'), 'sub.domain.org');
      });

      test('should return original string for invalid URL', () {
        expect(AppUtils.getDomainFromUrl('not-a-url'), 'not-a-url');
      });
    });

    group('Error Message Formatting', () {
      test('should format common errors correctly', () {
        expect(
          AppUtils.formatErrorMessage('Invalid login credentials'),
          'Invalid email or password. Please try again.',
        );
        expect(
          AppUtils.formatErrorMessage('Network request failed'),
          'Network error. Please check your connection and try again.',
        );
      });

      test('should return generic message for unknown errors', () {
        expect(
          AppUtils.formatErrorMessage('Some random error'),
          'Something went wrong. Please try again later.',
        );
        expect(
          AppUtils.formatErrorMessage(null),
          'An unknown error occurred',
        );
      });
    });
  });
}