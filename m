Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4478A1A2390
	for <linux-sgx@vger.kernel.org>; Tue, 29 Jul 2025 17:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753810965; cv=none; b=IprUag9U1eONNV8U1GcGXDGBJ4Ff/bsJDzOfOh1SKmUBkMHnCR6iQ9hvdJIVSVD0FEdLslfsUnFe0IBy5/6FZ2mS/ZaR9wlr6he6t6ehxKvEfuPetUYhE92/hbH9u14KoxsMxb7nuNMR0qGw4+DPK5pJ1tgF7VUNdqed1JM6OeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753810965; c=relaxed/simple;
	bh=e7H65OUTTySjbVhc8bnRw+W3Xmwc3ESREGLczzyVkRw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ifSG+XGRSI7eh/GCLCNtSNuiWeURjpgER13Cnmeez0ne7YHn1RYDjQ9lWaPKxhAF5TA97duKS9rMoMogeBxitLpdyqBcx9OVETkf9KZiWA/gy1GqJw9ATW9RqhYv9x2aqUd1FmErkj7j86YFV1jQo8v77tESVWG5+mCYEPec/k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XqoIF3wN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XqoIF3wN"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31eac278794so3294053a91.3
        for <linux-sgx@vger.kernel.org>; Tue, 29 Jul 2025 10:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753810961; x=1754415761; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82FN5fIR/hwkzJS9jFM+jcYFsAggMEElUtfqK1j0Xxw=;
        b=XqoIF3wNBNXflx66ataHWznDp2fURzByURZid/z1hQt5FuBQmx6cNCRiOcgAWDPzSO
         R6/k0GVWZePqYmVc+pJeRZRDiVdAKoRQr7fgwX7olNm9tu2iLaNT/PHae5V1shBhiWeb
         U3wflnnHUCN9BN+9DDfIblw2QIPtBRcmedDYBKadi2kwppStXrvhmEyeOTqVuZnkiw5x
         3YU4aCCWMlsB1uTQ0HrombvUqmWl+IFpxraxqnYJd2VYyCFkeZqJCwcPkIsFD+bAkMbP
         gjQ61f/iqhv9gk4OygRbmzT9K+fE9QJSvrvjUzkjvrg1Q2XaiND9wsbRIjml9A0lJ6Hj
         Zkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753810961; x=1754415761;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82FN5fIR/hwkzJS9jFM+jcYFsAggMEElUtfqK1j0Xxw=;
        b=trDzd9w9cVwDdH6v7yKDjbPJghcZ6FVO6rj6uH8uk/6JAexqDgvGnNgorWfyANBmar
         XGec6clvKkyVYhlkCiL01CNu9MEZkpjgoPZ94qUAK3r+w9W5YYRMmSPYrXCB8JImpYJ+
         TPX9AOjBKQybXvZq311iiGk+Uj71t+LlUaYRPhDLFldAJVqehVkY5CRgI50dWNxPrOj8
         psxuCeyd2LW/nzFtE4GATp8p4Z8FqRPw94y4vJnEZtQXshwlRySGlvccBh/sqOGtdwJj
         WLg3hrgZSA5/0BEhrkkyBQMnQm4znrwe5eG5E5fJD0fyli2owqtKgECirWPgp63vrHDg
         rECw==
X-Forwarded-Encrypted: i=1; AJvYcCW10ANjJ3HZEnKMie+slx+1uPY0wyOV1RpXtwqtOaJugTm2/+XO4zlexWjOZkbPGPsRFyRPYf1Fh+s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz65IgCOO0xnnSpWUiqw9DA+ZdT5Zf2tvauKnaRhxQntZGQA5k+
	FTdZEzQRKHjKsjIyiuJEZK1+WhhSVRrdXL8BsmY8ejJFFxq5QS1o/QSIA30kBz5BHgmmK4MBk9M
	Z9+5X/Q==
X-Google-Smtp-Source: AGHT+IHL9uyOCJhKfXzpWPYdk2ktpEDltn10+YA1InNR0RiEZWVGuenP/JjoNtMCTI8JhTdD+YDYzrbjaOw=
X-Received: from pjv8.prod.google.com ([2002:a17:90b:5648:b0:31f:37f:d381])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e706:b0:312:daf3:bac9
 with SMTP id 98e67ed59e1d1-31f5de69a49mr434036a91.34.1753810961444; Tue, 29
 Jul 2025 10:42:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 10:42:32 -0700
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729174238.593070-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: Export KVM-internal symbols for sub-modules only
From: Sean Christopherson <seanjc@google.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Tony Krowiak <akrowiak@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Jason Herne <jjherne@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>, 
	Holger Dengler <dengler@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-sgx@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use the newfangled EXPORT_SYMBOL_GPL_FOR_MODULES() along with some macro
shenanigans to export KVM-internal symbols if and only if KVM has one or
more sub-modules, and only for those sub-modules, e.g. x86's kvm-amd.ko
and/or kvm-intel.ko.

Patch 5 gives KVM x86 the full treatment.  If anyone wants to tackle PPC,
it should be doable to restrict KVM PPC's exports as well.

Patch 6 is essentially an RFC; it compiles and is tested, but it probably
should be chunked into multiple patches.  The main reason I included it
here is to get feedback on using kvm_types.h to define the "for KVM" macros.
For KVM itself, kvm_types.h is a solid choice, but it feels a bit awkward
for non-KVM usage, and including linux/kvm_types.h in non-KVM generic code,
e.g. in kernel/, isn't viable at the moment because asm/kvm_types.h is only
provided by architectures that actually support KVM.

Based on kvm/queue.

Sean Christopherson (6):
  KVM: s390/vfio-ap: Use kvm_is_gpa_in_memslot() instead of open coded
    equivalent
  KVM: Export KVM-internal symbols for sub-modules only
  KVM: x86: Move kvm_intr_is_single_vcpu() to lapic.c
  KVM: x86: Drop pointless exports of kvm_arch_xxx() hooks
  KVM: x86: Export KVM-internal symbols for sub-modules only
  x86: Restrict KVM-induced symbol exports to KVM modules where
    obvious/possible

 arch/powerpc/include/asm/kvm_types.h |  15 ++
 arch/s390/include/asm/kvm_host.h     |   2 +
 arch/s390/kvm/priv.c                 |   8 +
 arch/x86/entry/entry.S               |   7 +-
 arch/x86/entry/entry_64_fred.S       |   3 +-
 arch/x86/events/amd/core.c           |   5 +-
 arch/x86/events/core.c               |   7 +-
 arch/x86/events/intel/lbr.c          |   3 +-
 arch/x86/events/intel/pt.c           |   7 +-
 arch/x86/include/asm/kvm_host.h      |   3 -
 arch/x86/include/asm/kvm_types.h     |  15 ++
 arch/x86/kernel/apic/apic.c          |   3 +-
 arch/x86/kernel/apic/apic_common.c   |   3 +-
 arch/x86/kernel/cpu/amd.c            |   4 +-
 arch/x86/kernel/cpu/bugs.c           |  17 +--
 arch/x86/kernel/cpu/bus_lock.c       |   3 +-
 arch/x86/kernel/cpu/common.c         |   7 +-
 arch/x86/kernel/cpu/sgx/main.c       |   3 +-
 arch/x86/kernel/cpu/sgx/virt.c       |   5 +-
 arch/x86/kernel/e820.c               |   3 +-
 arch/x86/kernel/fpu/core.c           |  21 +--
 arch/x86/kernel/fpu/xstate.c         |   7 +-
 arch/x86/kernel/hw_breakpoint.c      |   3 +-
 arch/x86/kernel/irq.c                |   3 +-
 arch/x86/kernel/kvm.c                |   5 +-
 arch/x86/kernel/nmi.c                |   5 +-
 arch/x86/kernel/process_64.c         |   5 +-
 arch/x86/kernel/reboot.c             |   5 +-
 arch/x86/kernel/tsc.c                |   1 +
 arch/x86/kvm/cpuid.c                 |  10 +-
 arch/x86/kvm/hyperv.c                |   4 +-
 arch/x86/kvm/irq.c                   |  34 +----
 arch/x86/kvm/kvm_onhyperv.c          |   6 +-
 arch/x86/kvm/lapic.c                 |  70 ++++++---
 arch/x86/kvm/lapic.h                 |   4 +-
 arch/x86/kvm/mmu/mmu.c               |  36 ++---
 arch/x86/kvm/mmu/spte.c              |  10 +-
 arch/x86/kvm/mmu/tdp_mmu.c           |   2 +-
 arch/x86/kvm/pmu.c                   |   8 +-
 arch/x86/kvm/smm.c                   |   2 +-
 arch/x86/kvm/x86.c                   | 211 +++++++++++++--------------
 arch/x86/lib/cache-smp.c             |   9 +-
 arch/x86/lib/msr.c                   |   5 +-
 arch/x86/mm/pat/memtype.c            |   3 +-
 arch/x86/mm/tlb.c                    |   5 +-
 arch/x86/virt/vmx/tdx/tdx.c          |  65 +++++----
 drivers/s390/crypto/vfio_ap_ops.c    |   2 +-
 include/linux/kvm_types.h            |  39 ++++-
 virt/kvm/eventfd.c                   |   2 +-
 virt/kvm/guest_memfd.c               |   4 +-
 virt/kvm/kvm_main.c                  | 126 ++++++++--------
 51 files changed, 457 insertions(+), 378 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_types.h


base-commit: beafd7ecf2255e8b62a42dc04f54843033db3d24
-- 
2.50.1.552.g942d659e1b-goog

