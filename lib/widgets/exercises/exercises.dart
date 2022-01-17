/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/exercises/muscle.dart';
import 'package:wger/providers/exercises.dart';
import 'package:wger/widgets/core/core.dart';
import 'package:wger/widgets/exercises/images.dart';
import 'package:wger/widgets/exercises/list_tile.dart';

class ExerciseDetail extends StatelessWidget {
  final Exercise _exercise;

  const ExerciseDetail(this._exercise);

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExercisesProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Text(
            _exercise.name,
            style: Theme.of(context).textTheme.headline5,
          ),

          Pill(
            title: _exercise.category.name,
          ),
          const SizedBox(height: 8),

          const MutedText('Also known as: Burpees, Basic burpees'),

          const SizedBox(height: 8),

          ExerciseImageWidget(
            image: _exercise.getMainImage,
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            AppLocalizations.of(context).description,
            style: Theme.of(context).textTheme.headline6,
          ),
          Html(data: _exercise.description),

          // Notes
          Text(
            AppLocalizations.of(context).notes,
            style: Theme.of(context).textTheme.headline6,
          ),
          ..._exercise.tips.map((e) => Text(e.comment)).toList(),

          // Muscles
          Text(
            AppLocalizations.of(context).muscles,
            style: Theme.of(context).textTheme.headline6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MuscleWidget(_exercise.muscles),
              MuscleWidget(_exercise.musclesSecondary),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context).muscles,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._exercise.muscles.map((e) => Text(e.name)).toList(),
                ],
              ),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context).musclesSecondary,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._exercise.musclesSecondary.map((e) => Text(e.name)).toList(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Variants
          Text(
            'Variants',
            style: Theme.of(context).textTheme.headline6,
          ),

          if (_exercise.base.variationId != null)
            ...exerciseProvider
                .findExercisesByVariationId(
                  _exercise.base.variationId!,
                  languageId: _exercise.languageId,
                  exerciseIdToExclude: _exercise.id,
                )
                .map((exercise) => ExerciseListTile(exercise: exercise))
                .toList()
          else
            const Text('no variations!'),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class MuscleWidget extends StatelessWidget {
  List<Muscle> muscles = [];

  MuscleWidget(
    this.muscles, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset('assets/images/muscles/front.svg'),
        ...muscles
            .map((m) => SvgPicture.asset('assets/images/muscles/main/muscle-${m.id}.svg'))
            .toList(),
      ],
    );
  }
}
