import 'package:flutter/material.dart';
import '../views/add_interest_screen.dart';

class ProfileInterestsSection extends StatelessWidget {
  final List<String> interests;

  const ProfileInterestsSection({super.key, required this.interests});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 5, 0, 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 22, 35, 41),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Interest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pushNamed(
                  AddInterestScreen.routeName,
                  arguments: interests,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
          if (interests.isEmpty)
            const Text(
              'Add in your interest to find a better match',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          if (interests.isNotEmpty)
            Wrap(
              spacing: 8.0, // Space between chips
              runSpacing: 4.0, // Space between lines
              children: interests
                  .map(
                    (interest) => Chip(
                      label: Text(interest),
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.blueGrey.shade900,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
