Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF96017BA5
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757674; cv=none; b=dM3iui+dfGWdzUhLMPCVDYzjG8SHoXar5UUHrvpwBuCYuSQMFAgTC3WhwwAwhIbMNwf0IJlYt0Ct8mWfLP7XTkXxycSnP3FAKQJ6JoZs8Wuclk/XbQLdW8gqcEoHZVTNMiGylfa5hZmZ6DL6itvE+OeeTK+OA1lcX0Yyvo8D1ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757674; c=relaxed/simple;
	bh=zaQrYUFSoVVj5jkWe13qQb89eZrH1OPx1fUQQisOQ7I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZTkA8fvqMr6rX6NvpufqQMqJASjkiyJ1USdav4PcFJGH3QL0xFvjhKL7Ezi35mVEIpqvV3nBSfZhEu5cpZG57ORm9kQK4BpC5VTzN7cEBLQAp3legvniInw8qqh97uvaKA2IvCwHaQxRRRJaVawzjohp9OqkxBsDJsj/ZPgiXrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N1pXNPVi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N1pXNPVi"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea3512feaeso443461a91.2
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757672; x=1733362472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9RTQ1RXShdFrDsr7LeePShhmaFBmV2+IpZyR+7AtfGA=;
        b=N1pXNPVi+yr5qs0PbR9j1h88srwElWuKQxT/4hs3psGjTnzMCJ1q6Pj5NYPHfq20/z
         ZIp3Bonf2FRZTFRwYsuHRq69F9Q4pZnYdSE3E79tqMLyN+OMIphgndXYC4wfle1fGxRN
         4OfXXTMvU/E/ON3crHGLDy/Uv/5StCzudq6SNfqpFV3jj4PMaF8gG93rBjvz4xUV8B/t
         4Z6P0k5J03RkTaRzoA317nuniGbxP1Og6fZ3QXSSSeFFQSil5u4U8IE2nfy9peJuFmeZ
         IdbVDouaP+SQ3IJ2cqRnb9iT/nEfLtDfxGf8JLMsTWM+vOqfPEkZpiE36WJsuMkLPfPN
         8Nlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757672; x=1733362472;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9RTQ1RXShdFrDsr7LeePShhmaFBmV2+IpZyR+7AtfGA=;
        b=EgMDoO+2PnqZiFpzsvCRErnlH6J5dAJUsXFFHoJG/LslDcK5qs03omPx6m5/Q+xQPu
         UzjSviV9XJxz09vfH1QKCPkLRKVPXs0OYTZepLXF+ZIv4YsMrNB/SiV6irY5NE6F4/vG
         0qCLamAEvJLtqWdQ9oUBPfOXBgEe3kk9V0M2ebDxSrCfYZZWIr1xBmOUWYbm242Vd18m
         ncpTpTYV4KXI9xZ/ohn42FdUrM6UjJieIlPsCPGk3GN/F8z4ISjfwVH+/4rMInaYagTc
         fEkH2n3BVck45BSp44ciThCYm2O3cQEDOpScassDgUcPxXZeY9zD/IiFFzCISHS9ZGEk
         kmIg==
X-Forwarded-Encrypted: i=1; AJvYcCXkvq5X1zci93YxTV6YQpnJgAzkvVnkLtp6atCq+xMkGRxvW0JU6UtHqrmEVebZ/0XBAgcgjIIHXPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFi9t3XKrr9ThcfdHQewIMZoMGzOqORVVen4nWFZ9Sdwe6EC+A
	slVW6Gdp93LnZWYNsRI9CHWeZBrHE4yyp4tn0vQrDChDNyDuN3FxTisg1lK4KXq7j52l7raDNIP
	wdA==
X-Google-Smtp-Source: AGHT+IHrLvTXZ5LEsjAuC6TpUvILdjM6MK9BvKWntm8r0KpUVhamk0VaSj7+SaxYGY+dhbrvo7j8zHyBUR4=
X-Received: from pjbsx16.prod.google.com ([2002:a17:90b:2cd0:b0:2e9:29d3:c920])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3947:b0:2ea:9309:75b3
 with SMTP id 98e67ed59e1d1-2ee08e9d29amr6252973a91.2.1732757672288; Wed, 27
 Nov 2024 17:34:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:27 -0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-1-seanjc@google.com>
Subject: [PATCH v3 00/57] KVM: x86: CPUID overhaul, fixes, and caching
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

The super short TL;DR: snapshot all X86_FEATURE_* flags that KVM cares
about so that all queries against guest capabilities are "fast", e.g. don't
require manual enabling or judgment calls as to where a feature needs to be
fast.

The guest_cpu_cap_* nomenclature follows the existing kvm_cpu_cap_*
except for a few (maybe just one?) cases where guest cpu_caps need APIs
that kvm_cpu_caps don't.  In theory, the similar names will make this
approach more intuitive.

This series also adds more hardening, e.g. to assert at compile-time if a
feature flag is passed to the wrong word.  It also sets the stage for even
more hardening in the future, as tracking all KVM-supported features allows
shoving known vs. used features into arrays at compile time, which can then
be checked for consistency irrespective of hardware support.  E.g. allows
detecting if KVM is checking a feature without advertising it to userspace.
This extra hardening is future work; I have it mostly working, but it's ugly
and requires a runtime check to process the generated arrays.

There are *multiple* potentially breaking changes in this series (in for a
penny, in for a pound).  However, I don't expect any fallout for real world
VMMs because the ABI changes either disallow things that couldn't possibly
have worked in the first place, or are following in the footsteps of other
behaviors, e.g. KVM advertises x2APIC, which is 100% dependent on an in-kernel
local APIC.

 * Disallow stuffing CPUID-dependent guest CR4 features before setting guest
   CPUID.
 * Disallow KVM_CAP_X86_DISABLE_EXITS after vCPU creation
 * Reject disabling of MWAIT/HLT interception when not allowed
 * Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID.
 * Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID

Validated the flag rework by comparing the output of KVM_GET_SUPPORTED_CPUID
(and the emulated version) at the beginning and end of the series, on AMD
and Intel hosts that should support almost every feature known to KVM.

Maxim, I did my best to incorporate all of your feedback, and when we
disagreed, I tried to find an approach that I we can hopefully both live
with, at least until someone comes up with a better idea.

I _think_ the only suggestion that I "rejected" entirely is the existence
of ALIASED_1_EDX_F.  I responded to the previous thread, definitely feel
free to continue the conversation there (or here).

If I missed something you care strongly about, please holler!

v3:
 - Collect more reviews.
 - Too many to list.
 
v2:
 - Collect a few reviews (though I dropped several due to the patches changing
   significantly).
 - Incorporate KVM's support into the vCPU's cpu_caps. [Maxim]
 - A massive pile of new patches.

Sean Christopherson (57):
  KVM: x86: Use feature_bit() to clear CONSTANT_TSC when emulating CPUID
  KVM: x86: Limit use of F() and SF() to
    kvm_cpu_cap_{mask,init_kvm_defined}()
  KVM: x86: Do all post-set CPUID processing during vCPU creation
  KVM: x86: Explicitly do runtime CPUID updates "after" initial setup
  KVM: x86: Account for KVM-reserved CR4 bits when passing through CR4
    on VMX
  KVM: selftests: Update x86's set_sregs_test to match KVM's CPUID
    enforcement
  KVM: selftests: Assert that vcpu->cpuid is non-NULL when getting CPUID
    entries
  KVM: selftests: Refresh vCPU CPUID cache in __vcpu_get_cpuid_entry()
  KVM: selftests: Verify KVM stuffs runtime CPUID OS bits on CR4 writes
  KVM: x86: Move __kvm_is_valid_cr4() definition to x86.h
  KVM: x86/pmu: Drop now-redundant refresh() during init()
  KVM: x86: Drop now-redundant MAXPHYADDR and GPA rsvd bits from vCPU
    creation
  KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS after vCPU creation
  KVM: x86: Reject disabling of MWAIT/HLT interception when not allowed
  KVM: x86: Drop the now unused KVM_X86_DISABLE_VALID_EXITS
  KVM: selftests: Fix a bad TEST_REQUIRE() in x86's KVM PV test
  KVM: selftests: Update x86's KVM PV test to match KVM's disabling
    exits behavior
  KVM: x86: Zero out PV features cache when the CPUID leaf is not
    present
  KVM: x86: Don't update PV features caches when enabling enforcement
    capability
  KVM: x86: Do reverse CPUID sanity checks in __feature_leaf()
  KVM: x86: Account for max supported CPUID leaf when getting raw host
    CPUID
  KVM: x86: Unpack F() CPUID feature flag macros to one flag per line of
    code
  KVM: x86: Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init()
  KVM: x86: Add a macro to init CPUID features that are 64-bit only
  KVM: x86: Add a macro to precisely handle aliased 0x1.EDX CPUID
    features
  KVM: x86: Handle kernel- and KVM-defined CPUID words in a single
    helper
  KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to avoid macro collisions
  KVM: x86: Harden CPU capabilities processing against out-of-scope
    features
  KVM: x86: Add a macro to init CPUID features that ignore host kernel
    support
  KVM: x86: Add a macro to init CPUID features that KVM emulates in
    software
  KVM: x86: Swap incoming guest CPUID into vCPU before massaging in
    KVM_SET_CPUID2
  KVM: x86: Clear PV_UNHALT for !HLT-exiting only when userspace sets
    CPUID
  KVM: x86: Remove unnecessary caching of KVM's PV CPUID base
  KVM: x86: Always operate on kvm_vcpu data in cpuid_entry2_find()
  KVM: x86: Move kvm_find_cpuid_entry{,_index}() up near
    cpuid_entry2_find()
  KVM: x86: Remove all direct usage of cpuid_entry2_find()
  KVM: x86: Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID
  KVM: x86: Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID
  KVM: x86: Rename "governed features" helpers to use "guest_cpu_cap"
  KVM: x86: Replace guts of "governed" features with comprehensive
    cpu_caps
  KVM: x86: Initialize guest cpu_caps based on guest CPUID
  KVM: x86: Extract code for generating per-entry emulated CPUID
    information
  KVM: x86: Treat MONTIOR/MWAIT as a "partially emulated" feature
  KVM: x86: Initialize guest cpu_caps based on KVM support
  KVM: x86: Avoid double CPUID lookup when updating MWAIT at runtime
  KVM: x86: Drop unnecessary check that cpuid_entry2_find() returns
    right leaf
  KVM: x86: Update OS{XSAVE,PKE} bits in guest CPUID irrespective of
    host support
  KVM: x86: Update guest cpu_caps at runtime for dynamic CPUID-based
    features
  KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
  KVM: x86: Replace (almost) all guest CPUID feature queries with
    cpu_caps
  KVM: x86: Drop superfluous host XSAVE check when adjusting guest
    XSAVES caps
  KVM: x86: Add a macro for features that are synthesized into
    boot_cpu_data
  KVM: x86: Pull CPUID capabilities from boot_cpu_data only as needed
  KVM: x86: Rename "SF" macro to "SCATTERED_F"
  KVM: x86: Explicitly track feature flags that require vendor enabling
  KVM: x86: Explicitly track feature flags that are enabled at runtime
  KVM: x86: Use only local variables (no bitmask) to init kvm_cpu_caps

 Documentation/virt/kvm/api.rst                |  10 +-
 arch/x86/include/asm/kvm_host.h               |  47 +-
 arch/x86/kvm/cpuid.c                          | 967 ++++++++++++------
 arch/x86/kvm/cpuid.h                          | 128 +--
 arch/x86/kvm/governed_features.h              |  22 -
 arch/x86/kvm/hyperv.c                         |   2 +-
 arch/x86/kvm/lapic.c                          |   4 +-
 arch/x86/kvm/mmu.h                            |   2 +-
 arch/x86/kvm/mmu/mmu.c                        |   4 +-
 arch/x86/kvm/pmu.c                            |   1 -
 arch/x86/kvm/reverse_cpuid.h                  |  23 +-
 arch/x86/kvm/smm.c                            |  10 +-
 arch/x86/kvm/svm/nested.c                     |  22 +-
 arch/x86/kvm/svm/pmu.c                        |   8 +-
 arch/x86/kvm/svm/sev.c                        |  21 +-
 arch/x86/kvm/svm/svm.c                        |  46 +-
 arch/x86/kvm/svm/svm.h                        |   4 +-
 arch/x86/kvm/vmx/hyperv.h                     |   2 +-
 arch/x86/kvm/vmx/nested.c                     |  18 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |   4 +-
 arch/x86/kvm/vmx/sgx.c                        |  14 +-
 arch/x86/kvm/vmx/vmx.c                        |  61 +-
 arch/x86/kvm/x86.c                            | 153 ++-
 arch/x86/kvm/x86.h                            |   6 +-
 include/uapi/linux/kvm.h                      |   4 -
 .../selftests/kvm/include/x86_64/processor.h  |  18 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  38 +-
 .../selftests/kvm/x86_64/set_sregs_test.c     |  63 +-
 28 files changed, 1017 insertions(+), 685 deletions(-)
 delete mode 100644 arch/x86/kvm/governed_features.h


base-commit: 4d911c7abee56771b0219a9fbf0120d06bdc9c14
-- 
2.47.0.338.g60cca15819-goog

