Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0A2C433E6
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Jan 2021 03:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD23224B1
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Jan 2021 03:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbhARD3n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 17 Jan 2021 22:29:43 -0500
Received: from mga12.intel.com ([192.55.52.136]:16942 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731627AbhARD3e (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 17 Jan 2021 22:29:34 -0500
IronPort-SDR: gYXGw+gVOljQThMu/er1QLIOjDSUhDtblXnmimjwN8MMTV5DVwhcVOMTVGjrac7sTI3hhf+S4e
 3zv+l+cfsKLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="157933893"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="157933893"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:53 -0800
IronPort-SDR: Gwa0CtVZA9dRNTEOkXBM31nblf6t7YQn17sXqbfv0C2KxhNaqFPPs5RS3OLls4KmDgi+s/CZnC
 KSM5p1KPEh8w==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573151089"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:49 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 16/26] KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
Date:   Mon, 18 Jan 2021 16:28:27 +1300
Message-Id: <347d84df280cc326ebdb097ab3a30aed2818ae8c.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Export the gva_to_gpa() helpers for use by SGX virtualization when
executing ENCLS[ECREATE] and ENCLS[EINIT] on behalf of the guest.
To execute ECREATE and EINIT, KVM must obtain the GPA of the target
Secure Enclave Control Structure (SECS) in order to get its
corresponding HVA.

Because the SECS must reside in the Enclave Page Cache (EPC), copying
the SECS's data to a host-controlled buffer via existing exported
helpers is not a viable option as the EPC is not readable or writable
by the kernel.

SGX virtualization will also use gva_to_gpa() to obtain HVAs for
non-EPC pages in order to pass user pointers directly to ECREATE and
EINIT, which avoids having to copy pages worth of data into the kernel.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..5ca7b181a3ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5891,6 +5891,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
 
  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception)
@@ -5907,6 +5908,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 	access |= PFERR_WRITE_MASK;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_write);
 
 /* uses this to access any guest's mapped memory without checking CPL */
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
-- 
2.29.2

