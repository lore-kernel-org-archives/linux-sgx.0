Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B91346E5E
	for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969189; cv=none; b=R7ZiFy3Y0/JuIKUMi8SfoqaLoHgaTrPanMyCHHIv0q41YToSORQwe0prhqOzEHr6IzG36uocNA6YBU7ovaVbzTcgZU8bT+wLwFC5VCyRVYHN32D6cgLtjAS+su+veYGZjffpiscXSswRZ8loSb5TjYFAZOu3AEEf6C4zrt+watI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969189; c=relaxed/simple;
	bh=cQTvfgJcnon9Tazw0uXymglv7tr+UGFUUQGDrTC8H5s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BArDFVbcaGgN430gu+zsNUYbK7m+QXg688NJv4a0SWmgl7n/sGV2d4mXN4tKiomd0IGW3g0neIfcb71Y0mE0WePzCEj2cmIlqvSVCVlLSjschrAezGiGiJDiFRyHNt0Cc8oERHqSvixE+2lD4aB+ODaLeusblHtnl+WH7/QjI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gO8rYmsX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gO8rYmsX"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343725e6243so998791a91.1
        for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 09:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762969187; x=1763573987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Al8Jq0oWPVD59rhTUTD0bttySyzqdJx7uMImvbMrtTk=;
        b=gO8rYmsXYqP16oDY9GqSBsWpQRrYgK9+s/Sgnvaqo1md50DnX4oEtQpTxWKe2nBAbD
         a0FkAtgn9g+pZwBZXyti1UOkZKFJi2p64MFpqXdjGfeXo3tXA1Rq+6SckjQd9l/pHhGP
         vdE++uICVE/mq39pVcaym2rYA0Wu2Zi8eon//em5ye/4YM5QQx5P1iUByCtPybut7+Gg
         0VYj0hJhgeTDSU3ulcjlm/Zhz/vC85tL8clVzX67aLigwm4fDkmSz0Q+ct9Xta4BPeeM
         rrJ9T6LoZZ2XnNOFXMIDpJXqdtmqMTJ2lbv/NDhn0OP0qXy2h9UJj+rCvgxIMGOWAWoM
         SjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969187; x=1763573987;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Al8Jq0oWPVD59rhTUTD0bttySyzqdJx7uMImvbMrtTk=;
        b=e++4DoGNoc3K4PqjW9buaVEDvxbhaUOve5wOfHSWAadqVrHOnAKbac1EDRs4dkzA7r
         asJEvZbeSu/V3oFJSJiDgbJt+hmTExOT7vWHdWSCyYjDPwpmrT7KzjGdws60XpK6GQz+
         Mji+4q6UpBA6ggBhHPAy+/BC8GCsyVNjHCaCo3HCUfqn/exGDd3mIBja5aTzPOV2O+rs
         3bcRwZVVmaT/iauqDNYJ00K9yYHLVt3P6xBqXfs7u8aA1mGy3Lln26jMFO1DddPuVXqd
         12yMNjVjtssH0I3HIUyZ6YQk8CXsUb20dnolW5raWcLs8dstwyMLwgV+UQDgGhX9szNa
         jGHg==
X-Forwarded-Encrypted: i=1; AJvYcCWuclKJZuw3hwQoKMF/aqneZ0Ps9RXNF6iJN/hEfgx6mZESHpiW52vh9JsrAw9u7dsmivuVbdNx2q4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuvqyjyzmVExD9SGu/7FnMB9qgkWON+o2Z7Bt3eL58okbTKuVq
	ANciG1ghkgSFHjpPisPKN38osMUZTHgdIWT4uD5NbS9lGR4JS0OF2L0UF33ZOXfkb9TimCfimeH
	n5de5YA==
X-Google-Smtp-Source: AGHT+IFPhXy58yihQJ69w+xNEF4NV2MXVm+vSkkcvlcTqNBe2Kw+QHSUNQCz0RwaERkCFBa+qLKJT/z5qkw=
X-Received: from pjnx3.prod.google.com ([2002:a17:90a:8a83:b0:340:e8f7:1b44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5201:b0:32e:3592:581a
 with SMTP id 98e67ed59e1d1-343eaca9dbfmr208175a91.17.1762969187027; Wed, 12
 Nov 2025 09:39:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 09:39:40 -0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112173944.1380633-1-seanjc@google.com>
Subject: [PATCH 0/4] x86: Restrict KVM-induced symbol exports to KVM
From: Sean Christopherson <seanjc@google.com>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org, linux-coco@lists.linux.dev, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Leverage and extend KVM's macro shenanigans to export symbols for KVM if
and only if kvm{,-amd,intel}.ko is being built as a module, and only for
the KVM modules that are being built.

Note, this approach isn't 100% precise, as exports that are only strictly
necessary for one of KVM's modules will get exported for all KVM modules.
But I don't see any value in being super precise as it's not like kvm.ko is
any more trustworthy tha kvm-{amd,intel}.ko (and it's easy to circumvent
"for module" exports by abusing module names (in out-of-tree code)).  And
maintaining precise exports would likely be a nightmare (as would writing
the macros to get the exports right).

Patches 1-3 drop superfluous exports that I found while digging around for
KVM-only exports.

Sean Christopherson (4):
  x86/bugs: Drop unnecessary export of "x86_spec_ctrl_base"
  x86/mtrr: Drop unnecessary export of "mtrr_state"
  x86/mm: Drop unnecessary export of "ptdump_walk_pgd_level_debugfs"
  x86: Restrict KVM-induced symbol exports to KVM modules where
    obvious/possible

 arch/x86/entry/entry.S             |  7 ++-
 arch/x86/entry/entry_64.S          |  3 +-
 arch/x86/entry/entry_64_fred.S     |  3 +-
 arch/x86/events/amd/core.c         |  5 ++-
 arch/x86/events/core.c             |  7 +--
 arch/x86/events/intel/lbr.c        |  3 +-
 arch/x86/events/intel/pt.c         |  7 +--
 arch/x86/include/asm/kvm_types.h   |  5 +++
 arch/x86/kernel/apic/apic.c        |  3 +-
 arch/x86/kernel/apic/apic_common.c |  3 +-
 arch/x86/kernel/cpu/amd.c          |  4 +-
 arch/x86/kernel/cpu/bugs.c         | 18 ++++----
 arch/x86/kernel/cpu/bus_lock.c     |  3 +-
 arch/x86/kernel/cpu/common.c       |  7 +--
 arch/x86/kernel/cpu/mtrr/generic.c |  1 -
 arch/x86/kernel/cpu/sgx/main.c     |  3 +-
 arch/x86/kernel/cpu/sgx/virt.c     |  5 ++-
 arch/x86/kernel/e820.c             |  3 +-
 arch/x86/kernel/fpu/core.c         | 21 ++++-----
 arch/x86/kernel/fpu/xstate.c       |  7 +--
 arch/x86/kernel/hw_breakpoint.c    |  3 +-
 arch/x86/kernel/irq.c              |  3 +-
 arch/x86/kernel/kvm.c              |  5 ++-
 arch/x86/kernel/nmi.c              |  5 +--
 arch/x86/kernel/process_64.c       |  5 +--
 arch/x86/kernel/reboot.c           |  5 ++-
 arch/x86/kernel/tsc.c              |  1 +
 arch/x86/lib/cache-smp.c           |  9 ++--
 arch/x86/lib/msr.c                 |  5 ++-
 arch/x86/mm/dump_pagetables.c      |  1 -
 arch/x86/mm/pat/memtype.c          |  3 +-
 arch/x86/mm/tlb.c                  |  5 ++-
 arch/x86/virt/vmx/tdx/tdx.c        | 69 +++++++++++++++---------------
 include/linux/kvm_types.h          | 14 ++++++
 34 files changed, 144 insertions(+), 107 deletions(-)


base-commit: 19e2126bba55df9de15d9100b922df1dad6d39a4
-- 
2.51.2.1041.gc1ab5b90ca-goog

