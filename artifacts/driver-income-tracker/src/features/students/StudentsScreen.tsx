import { useMemo, useState } from 'react';
import {
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { CalendarDays, Plus, Search } from 'lucide-react-native';
import {
  colors,
  iconSize,
  minTouchTargetSize,
  radius,
  spacing,
  typography,
} from '@/theme';

type PaymentStatus = 'Paid' | 'Due';

type Student = {
  id: string;
  name: string;
  monthlyFee: number;
  status: PaymentStatus;
};

const MOCK_STUDENTS: Student[] = [
  { id: 'ali-khan', name: 'Ali Khan', monthlyFee: 5000, status: 'Paid' },
  { id: 'ahmed-khan', name: 'Ahmed Khan', monthlyFee: 5000, status: 'Paid' },
  { id: 'usman-khan', name: 'Usman Khan', monthlyFee: 5000, status: 'Due' },
  { id: 'hamza-khan', name: 'Hamza Khan', monthlyFee: 4500, status: 'Paid' },
  { id: 'bilal-khan', name: 'Bilal Khan', monthlyFee: 5000, status: 'Paid' },
];

function formatFee(amount: number) {
  return `Rs. ${amount.toLocaleString('en-PK')}`;
}

function SummaryMetric({
  label,
  value,
  valueColor = colors.text,
}: {
  label: string;
  value: number;
  valueColor?: string;
}) {
  return (
    <View style={styles.summaryMetric}>
      <Text style={[styles.summaryValue, { color: valueColor }]}>{value}</Text>
      <Text style={styles.summaryLabel}>{label}</Text>
    </View>
  );
}

export function StudentsScreen() {
  const [searchQuery, setSearchQuery] = useState('');

  const filteredStudents = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLowerCase();

    if (!normalizedQuery) {
      return MOCK_STUDENTS;
    }

    return MOCK_STUDENTS.filter((student) =>
      student.name.toLowerCase().includes(normalizedQuery),
    );
  }, [searchQuery]);

  const paidCount = MOCK_STUDENTS.filter(
    (student) => student.status === 'Paid',
  ).length;
  const dueCount = MOCK_STUDENTS.length - paidCount;

  return (
    <SafeAreaView style={styles.screen} edges={['top', 'left', 'right']}>
      <ScrollView
        contentContainerStyle={styles.content}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.header}>
          <View>
            <Text style={styles.screenTitle}>Students</Text>
            <View style={styles.monthRow}>
              <CalendarDays
                color={colors.textSecondary}
                size={iconSize.sm}
                strokeWidth={2}
              />
              <Text style={styles.monthText}>August 2026</Text>
            </View>
          </View>

          <Pressable
            accessibilityLabel="Add student"
            accessibilityRole="button"
            accessibilityState={{ disabled: true }}
            disabled
            style={styles.headerAction}
          >
            <Plus color={colors.primary} size={iconSize.lg} strokeWidth={2} />
          </Pressable>
        </View>

        <View style={styles.summaryBar}>
          <SummaryMetric label="Total students" value={MOCK_STUDENTS.length} />
          <View style={styles.summaryDivider} />
          <SummaryMetric
            label="Paid"
            value={paidCount}
            valueColor={colors.income}
          />
          <View style={styles.summaryDivider} />
          <SummaryMetric
            label="Due"
            value={dueCount}
            valueColor={colors.expense}
          />
        </View>

        <View style={styles.searchField}>
          <Search
            color={colors.textSecondary}
            size={iconSize.md}
            strokeWidth={2}
          />
          <TextInput
            accessibilityLabel="Search students"
            autoCapitalize="words"
            clearButtonMode="while-editing"
            onChangeText={setSearchQuery}
            placeholder="Search students"
            placeholderTextColor={colors.textSecondary}
            returnKeyType="search"
            style={styles.searchInput}
            value={searchQuery}
          />
        </View>

        <View style={styles.listSection}>
          <Text style={styles.sectionTitle}>This month</Text>
          <View style={styles.studentList}>
            {filteredStudents.map((student) => {
              const statusColor =
                student.status === 'Paid' ? colors.income : colors.expense;

              return (
                <View key={student.id} style={styles.studentRow}>
                  <View style={styles.studentInfo}>
                    <Text style={styles.studentName}>{student.name}</Text>
                    <Text style={styles.studentFee}>
                      {formatFee(student.monthlyFee)} / month
                    </Text>
                  </View>
                  <View
                    style={[
                      styles.statusPill,
                      { borderColor: statusColor },
                    ]}
                  >
                    <Text style={[styles.statusText, { color: statusColor }]}>
                      {student.status}
                    </Text>
                  </View>
                </View>
              );
            })}

            {filteredStudents.length === 0 ? (
              <View style={styles.emptyState}>
                <Text style={styles.emptyTitle}>No students found</Text>
                <Text style={styles.emptyMessage}>
                  Try a different name.
                </Text>
              </View>
            ) : null}
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.background,
  },
  content: {
    paddingHorizontal: spacing.lg,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: spacing.lg,
  },
  screenTitle: {
    ...typography.screenTitle,
    color: colors.text,
  },
  monthRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
    marginTop: spacing.xs,
  },
  monthText: {
    ...typography.bodySmall,
    color: colors.textSecondary,
  },
  headerAction: {
    alignItems: 'center',
    justifyContent: 'center',
    minWidth: minTouchTargetSize,
    minHeight: minTouchTargetSize,
    borderRadius: radius.full,
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderWidth: StyleSheet.hairlineWidth,
  },
  summaryBar: {
    flexDirection: 'row',
    alignItems: 'stretch',
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderRadius: radius.md,
    borderWidth: StyleSheet.hairlineWidth,
    marginBottom: spacing.md,
    paddingVertical: spacing.md,
  },
  summaryMetric: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: spacing.sm,
  },
  summaryValue: {
    ...typography.sectionTitle,
  },
  summaryLabel: {
    ...typography.caption,
    color: colors.textSecondary,
    marginTop: spacing.xs,
    textAlign: 'center',
  },
  summaryDivider: {
    alignSelf: 'stretch',
    backgroundColor: colors.border,
    width: StyleSheet.hairlineWidth,
  },
  searchField: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderRadius: radius.md,
    borderWidth: StyleSheet.hairlineWidth,
    minHeight: minTouchTargetSize,
    paddingHorizontal: spacing.md,
    marginBottom: spacing.xl,
  },
  searchInput: {
    ...typography.bodySmall,
    color: colors.text,
    flex: 1,
    marginLeft: spacing.sm,
    minHeight: minTouchTargetSize,
    paddingVertical: 0,
  },
  listSection: {
    width: '100%',
  },
  sectionTitle: {
    ...typography.sectionTitle,
    color: colors.text,
    marginBottom: spacing.sm,
  },
  studentList: {
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderRadius: radius.md,
    borderWidth: StyleSheet.hairlineWidth,
    overflow: 'hidden',
  },
  studentRow: {
    alignItems: 'center',
    borderBottomColor: colors.border,
    borderBottomWidth: StyleSheet.hairlineWidth,
    flexDirection: 'row',
    justifyContent: 'space-between',
    minHeight: minTouchTargetSize + spacing.md,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },
  studentInfo: {
    flex: 1,
    paddingRight: spacing.sm,
  },
  studentName: {
    ...typography.body,
    color: colors.text,
  },
  studentFee: {
    ...typography.caption,
    color: colors.textSecondary,
    marginTop: spacing.xs,
  },
  statusPill: {
    borderRadius: radius.full,
    borderWidth: StyleSheet.hairlineWidth,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
  },
  statusText: {
    ...typography.caption,
  },
  emptyState: {
    alignItems: 'center',
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.xl,
  },
  emptyTitle: {
    ...typography.body,
    color: colors.text,
  },
  emptyMessage: {
    ...typography.bodySmall,
    color: colors.textSecondary,
    marginTop: spacing.xs,
  },
});