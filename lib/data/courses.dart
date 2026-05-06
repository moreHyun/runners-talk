import 'package:flutter/material.dart';
import '../models/course.dart';

// 코스 추가 시 여기에만 항목 넣으면 됩니다
const List<Course> kCourses = [
  Course(
    id: 'beginner',
    title: '러닝 초보자 코스',
    subtitle: '걷기부터 5분 달리기까지',
    level: CourseLevel.beginner,
    icon: Icons.emoji_people,
    weeks: 4,
    description: '지금까지 운동을 거의 안 했어도 OK.\n걷기와 달리기를 번갈아 몸을 깨워요.',
  ),
  Course(
    id: 'elementary',
    title: '러닝 초급 코스',
    subtitle: '5분 달리기 → 20분 연속 달리기',
    level: CourseLevel.elementary,
    icon: Icons.directions_run,
    weeks: 5,
    description: '조금씩 달릴 수 있는 분을 위한 코스.\n점진적으로 러닝 시간을 늘려갑니다.',
  ),
  Course(
    id: 'intermediate',
    title: '러닝 중급 코스',
    subtitle: '20분 이상 달릴 수 있는 러너',
    level: CourseLevel.intermediate,
    icon: Icons.speed,
    weeks: 6,
    description: '페이스와 인터벌 강도를 높여\n5km 완주를 목표로 합니다.',
  ),
];
