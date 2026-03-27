import 'package:flutter/material.dart';
import 'package:finlearn/screens/category_pdf_list_screen.dart';
import 'package:finlearn/screens/category_video_list.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final String queryName; // For Firestore query if different from display name

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
    this.queryName = '',
  });

  @override
  Widget build(BuildContext context) {
    final effectiveQueryName = queryName.isNotEmpty ? queryName : categoryName;

    // Get the list of videos (ID and Title) for the category
    final List<Map<String, String>> videos = _getVideosForCategory(
      effectiveQueryName,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'PDFs', icon: Icon(Icons.picture_as_pdf)),
              Tab(text: 'Videos', icon: Icon(Icons.video_library)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // PDF Tab
            CategoryPDFListScreen(
              categoryName: effectiveQueryName,
              isEmbedded: true,
            ),
            // Video Tab
            CategoryVideoList(videos: videos),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getVideosForCategory(String category) {
    switch (category) {
      case 'Foundational':
        return [
          {'id': 'GcZW24SkbHM', 'title': 'Why should you invest?'},
          {'id': 'C7_JHlsqFlM', 'title': 'Market Intermediaries'},
          {
            'id': 'SV7v5WRDtLE',
            'title': 'All about the Initial Public Offer (IPO)',
          },
          {'id': 'HaiM8jPDEhk', 'title': 'Why do stock prices fluctuate?'},
          {'id': '-h1R5oIL0PI', 'title': 'How does a trading platform work?'},
          {'id': 'z21PrHuEkKg', 'title': 'Stock Market Index'},
          {'id': '1ZrF6GCLDL4', 'title': 'Clearing and Settlement Process'},
          {
            'id': 'Mv93KfHcWaQ',
            'title': 'Corporate actions (Dividends, bonuses, and buybacks)',
          },
          {'id': '5t5O0MnNJNE', 'title': 'Order Types'},
          {'id': 'wt6YBnJzbm0', 'title': 'Getting started'},
        ];
      case 'Technical & Trading':
        return [
          {
            'id': 'yzRP-mA2eiE',
            'title':
                'Technical Analysis: Technical Analysis vs Fundamental Analysis',
          },
          {
            'id': '0uA1UJzTI4Q',
            'title': 'Technical Analysis: Setting expectations',
          },
          {'id': 'RNu14To1gdM', 'title': 'Technical Analysis: Chart Types'},
          {'id': 'pYC5RfXAm-4', 'title': 'Technical Analysis: Timeframes'},
          {
            'id': '37wji6rGKo4',
            'title': 'Technical Analysis: Key assumption of technical analysis',
          },
          {
            'id': 'AYG2g3O7jKc',
            'title': 'Technical Analysis: Understanding candlestick patterns',
          },
          {
            'id': 'mKfl8A1VOEM',
            'title': 'Technical Analysis: Single candlestick patterns',
          },
          {
            'id': 'yP83rD7DjTg',
            'title': 'Technical Analysis: Multiple candlestick patterns',
          },
          {
            'id': 'UBkCkBme2Hg',
            'title': 'Technical Analysis: Support and Resistance',
          },
          {
            'id': 'veWVgyucBqU',
            'title': 'Technical Analysis: Technical indicators',
          },
          {'id': '810jmf7drFw', 'title': 'Technical Analysis: Moving averages'},
          {
            'id': '4W0mOUNMWpc',
            'title': 'Technical Analysis: Your trading checklist',
          },
          {
            'id': 'J0sKv8cples',
            'title': 'Futures Trading: Introduction to forwards market',
          },
          {
            'id': 'Zo3iKIh5ncI',
            'title': 'Futures Trading: Introducing the futures contract',
          },
          {'id': 'deThGfn2CjA', 'title': 'Futures Trading: Margins'},
          {
            'id': 'LQTOx6TSyx4',
            'title': 'Futures Trading: Leverage and Payoff',
          },
          {'id': '7FGomEsahv8', 'title': 'Futures Trading: Futures trade'},
          {'id': 'jzq3rdwnyDM', 'title': 'Futures Trading: Settlement'},
          {'id': 'xMTG8gzen3Q', 'title': 'Futures Trading: Open Interest'},
          {'id': 'boJUi-qAFVk', 'title': 'Futures Trading: Shorting futures'},
          {
            'id': '8BD97VpzBrI',
            'title': 'Futures Trading: Overview of Contracts',
          },
        ];
      case 'Fundamental & Valuation Finance':
        return [
          {
            'id': '8rUc0MaMzik',
            'title':
                'Fundamental Analysis: Introduction to fundamental analysis',
          },
          {
            'id': 't-Fwh57MWDY',
            'title': 'Fundamental Analysis: Mindset of an investor',
          },
          {
            'id': 'pwF84tPRQu4',
            'title':
                'Fundamental Analysis: How to read the annual report of a company',
          },
          {
            'id': 'ukdZxF2qWfI',
            'title': 'Fundamental Analysis: Understanding the P&L statement',
          },
          {
            'id': 'iH3ODZ5PYU4',
            'title':
                'Fundamental Analysis: Understanding the Balance sheet statement',
          },
          {
            'id': 'uJG3SVrWzlQ',
            'title':
                'Fundamental Analysis: Understanding the Cash Flow Statement',
          },
          {
            'id': 's7mgGbKzs2k',
            'title':
                'Fundamental Analysis: The connection between balance sheet, P&L statement and cash flow statement',
          },
          {
            'id': 'B5HLwsehc-8',
            'title': 'Fundamental Analysis: The Financial Ratio Analysis',
          },
          {
            'id': 'ByCbte_e5PE',
            'title': 'Fundamental Analysis: Quick note on Relative Valuation',
          },
          {
            'id': 'Exbm-Bb5XCk',
            'title': 'Fundamental Analysis: Fundamental Investment Checklist',
          },
        ];
      case 'Derivatives':
        return [
          {
            'id': '-mO0YOTcCiQ',
            'title': 'Options Trading: Introduction to Options',
          },
          {'id': '54GRv6-18CA', 'title': 'Options Trading: Option Jargons'},
          {
            'id': 'jEHgjGrHFNU',
            'title': 'Options Trading: Long Call Payoff and Short Call Trade',
          },
          {
            'id': '48VEFNn2gbo',
            'title': 'Options Trading: Put Buy and Put Sell',
          },
          {
            'id': 'Ah9Kk6MCZ7o',
            'title': 'Options Trading: Summarizing Call & Put Options',
          },
          {
            'id': '3J9I0U9w4Ww',
            'title': 'Options Trading: Moneyness of option',
          },
          {
            'id': 'I7YWC_j1ocI',
            'title': 'Options Trading: The Option Greeks – Delta',
          },
          {'id': 'koJQc3fqxjk', 'title': 'Options Trading: Gamma'},
          {'id': 'fDLJlU8OdP8', 'title': 'Options Trading: Theta'},
          {'id': '2hmF5gqKEUg', 'title': 'Options Trading: Vega'},
          {
            'id': 'DLEWO3sUdno',
            'title': 'Options Trading: Options M2M and P&L calculation',
          },
          {
            'id': 'Llp4xW2GI4s',
            'title':
                'Options Trading: Physical settlement of futures and options',
          },
          {'id': 'uZAZAPnsqeo', 'title': 'Options Trading: Bull Call Spread'},
          {'id': 'IoMofuYx7cM', 'title': 'Options Trading: The Straddle'},
        ];
      case 'Risk,Tax & Regulations':
        return [
          {
            'id': 'sJR2gtPf_Ts',
            'title': 'Understanding Risk Management and its…',
          },
          {
            'id': 'PWsXTgciSBg',
            'title': 'What is Position Sizing in Risk management of Trading',
          },
          {
            'id': '9ZTkr19XypM',
            'title': 'Risk-Reward Ratio: The Secret to Profitable Trades',
          },
          {
            'id': 'wPuTkE5IqVw',
            'title': 'Risk Management Hacks for Money Management',
          },
          {
            'id': 'lKd3_LViIQA',
            'title': 'Power of Compounding | Investing and Trading',
          },
          {
            'id': '14-KmuDAPoA',
            'title': 'Protect Your Profits with Smarter Risk Management',
          },
          {
            'id': '1iVp39avRgk',
            'title':
                'Become a Profitable Trader Overnight with These Essentials',
          },
          {
            'id': 'CIzzkNo-LVM',
            'title': 'Want to Overcome Heavy Losses in Trading?',
          },
          {
            'id': 'V1g5EsMa9UE',
            'title': 'Plan Your Way to Financial Freedom in FY 2025?',
          },
          {
            'id': 'mVdcSSMrMJU',
            'title': 'Protect Your Money with Simple Risk Management',
          },
          {
            'id': '-31V7uFR1K0',
            'title':
                'Key Simple Tricks to Control Your Emotions After Entering a Trade',
          },
          {
            'id': 'EM0OgLTOVzA',
            'title': 'Want Maximum Profits? Try This Proven Trailing Stop Loss',
          },
        ];
      case 'Personal Finance':
        return [
          {
            'id': 'm2HiZG0Fhts',
            'title': 'Impact cost and how it can ruin a trade',
          },
          {'id': 'q-T2svXZ77s', 'title': '5 types of share capital'},
          {'id': 'hwiwWPrfWXU', 'title': 'How OFS allotment is done'},
          {'id': '6Zrl3ZeqqsE', 'title': 'Building a mutual fund portfolio'},
          {
            'id': 'haYmAB5d6T8',
            'title':
                'Should you invest in real estate stocks? How to analyse them?',
          },
        ];
      default:
        return [];
    }
  }
}
