import SwiftUI

// MARK: - 메인 프로필 화면

struct ProfileView: View {
    @StateObject private var profileViewModel: ProfileViewModel
    @Environment(\.diContainer) private var di
    @Environment(\.dismiss) var dismiss

    @State private var showSleepTimeModal = false
    @State private var showTargetSleepModal = false
    @State private var showMaxCaffeineModal = false
    
    init() {
        self._profileViewModel = StateObject(wrappedValue: ProfileViewModel())
    }

    var body: some View {
        HeaderBar(viewText: "프로필", onTapBack: { di.router.pop() })
        ZStack {
            Color(.systemBackground).ignoresSafeArea()   // 흰색 배경 유지
                VStack(spacing: 28) {
                    ProfileHeaderView(viewModel: profileViewModel)
                    personalSettingsSection
                    healthInfoSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
        }
        .sheet(isPresented: $showSleepTimeModal) {
            SleepTimeModalView(profileViewModel: profileViewModel)
        }
        .sheet(isPresented: $showTargetSleepModal) {
            TargetSleepModalView(profileViewModel: profileViewModel)
        }
        .sheet(isPresented: $showMaxCaffeineModal) {
            MaxCaffeineModalView(profileViewModel: profileViewModel)
        }
    }

    // MARK: - 서브 뷰들 분리

    private var personalSettingsSection: some View {
        ProfileSection(title: "개인 설정") {
            SettingRow(
                label: "평소 수면 시간대",
                value: formatSleepTimeRange(),
                action: { showSleepTimeModal = true }
            )

            SettingRow(
                label: "목표 수면 시간",
                value: formatTargetSleep(),
                action: { showTargetSleepModal = true }
            )

            Button(action: {
                profileViewModel.userInfo.step = 0
                profileViewModel.userInfo.completed = false
                profileViewModel.saveUserInfo()
                dismiss()
            }) {
                Text("카페인 민감도 재측정")
                    .font(.pretendard(.semiBold, size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.mainBrown)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
    }

    private var healthInfoSection: some View {
        ProfileSection(title: "건강 정보") {
            InfoRow(
                label: "심장이 과하게 뛴 경험",
                value: profileViewModel.getHeartRateText()
            )

            InfoRow(
                label: "1일 최대 카페인 제한치",
                value: "\(profileViewModel.userInfo.maxCaffeine) mg",
                showEdit: true,
                action: { showMaxCaffeineModal = true }
            )
        }
    }

    // MARK: - 포맷팅 함수

    private func formatSleepTimeRange() -> String {
        let bedtime = formatTime(profileViewModel.userInfo.bedtime)
        let wakeTime = formatTime(profileViewModel.userInfo.wakeTime)
        return "\(bedtime) ~ \(wakeTime)"
    }

    private func formatTime(_ time: String) -> String {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return time
        }

        let ampm = hour >= 12 ? "오후" : "오전"
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return "\(ampm) \(displayHour):\(String(format: "%02d", minute))"
    }

    private func formatTargetSleep() -> String {
        let hours = Int(profileViewModel.userInfo.targetSleep)
        let minutes = Int((profileViewModel.userInfo.targetSleep - Double(hours)) * 60)
        return minutes == 0 ? "\(hours)시간" : "\(hours)시간 \(minutes)분"
    }
}

// MARK: - 헤더 뷰

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 16) {
            Image(.profile)
                .resizable()
                .foregroundStyle(.mainBrown)
                .frame(width: 50, height: 50)
                .padding()
                .background(Color.cardBackground)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.dividerCol, lineWidth: 2)
                )

            HStack(spacing: 4) {
                Text("사용자")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundColor(.mainBrown)
                Text("님")
                    .font(.pretendard(.semiBold, size: 24))
                    .foregroundColor(.secondaryBrown)
            }

            Text("카페인 타입: \(viewModel.getCaffeineType())")
                .font(.pretendard(.medium, size: 17))
                .foregroundColor(.secondaryBrown)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color.sectionBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.dividerCol, lineWidth: 1)
        )
    }
}

// MARK: - 섹션/행 공통 뷰

struct ProfileSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.pretendard(.bold, size: 20))
                .foregroundColor(.mainBrown)
                .padding(.bottom, 4)

            VStack(spacing: 0) {
                content
            }
        }
        .padding(22)
        .background(Color.sectionBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.dividerCol, lineWidth: 1)
        )
    }
}

struct SettingRow: View {
    let label: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.mainBrown)

                Spacer()

                HStack(spacing: 8) {
                    Text(value)
                        .font(.pretendard(.medium, size: 15))
                        .foregroundColor(.secondaryBrown)
                    Image(systemName: "chevron.right")
                        .font(.pretendard(.semiBold, size: 12))
                        .foregroundColor(.mainBrown)
                }
            }
            .padding(.vertical, 14)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.dividerCol)
                    .frame(height: 1)
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var showEdit: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(label)
                .font(.pretendard(.medium, size: 16))
                .foregroundColor(.mainBrown)
            Spacer()
            HStack(spacing: 8) {
                Text(value)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.secondaryBrown)
                if showEdit {
                    Button(action: { action?() }) {
                        Text("수정")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundColor(.mainBrown)
                            .underline()
                    }
                }
            }
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.dividerCol)
                .frame(height: 1)
        }
    }
}

#Preview {
    ProfileView()
}
