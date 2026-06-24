Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D103C0A09;
	Wed, 24 Jun 2026 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782310790; cv=none; b=jiPxyn/45Fmkdb3nS3yHNUddraNWjouFY74YB6uI5U8RNuLj4DAr2PY4FUd9Tsw2NPLu5eHQq6+lZivg59Ovyp6FphjQbKZ6yCtHPxJFDVFhocnQdlYdO3CXxIMQxAR66GD7jIfhol7ZGUsQYVuBMJR2yWv/BMSdh8ubOI/jygI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782310790; c=relaxed/simple;
	bh=84PWD0Uc7GiZot0KFNUiPkqFUZWzdBLwSFfXa5jEycE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hdAi3SG2yAMof9VXwBiClgxs/s/Ue5St8WSTHSaKR/AxGj/ySIiHufL02BCTt+2eF7m+m0KnzSSU2HEYwj0IhbqW/5C2K2GhAEwlowZepJGktyt92MgRO9DSPeDzptMZpYPg7T/VDtvj0ql2n68VDDcHtl4MliSef7g8WwBV+Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oeh6e+Lh; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oeh6e+Lh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782310789; x=1813846789;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=84PWD0Uc7GiZot0KFNUiPkqFUZWzdBLwSFfXa5jEycE=;
  b=Oeh6e+Lh/cgoub9bnD0aLEhO6idSQnQfzu754QElu2qpYhwlR4OXewyG
   k11grguZSxh6ryF4exORJy1PXxMaJ2Lv0Pc7MjSeVJuqamDDd+t7tYOsp
   y0WMFCnNTrB9e8XqitzWRbR6Z4CPX8EnGLGzdrIcayqblSxoSUPBKpaWk
   UwT+WyVZmFXxjh4AI1XnUEIT5j2CybM9SOIbHtqGAs0Qctwx0MWJ//NG/
   rV9dCkhrLT2MzQlgucmq2CIqi/F8ED9+UopE3KjJUgFdDgRjAHW8muIck
   P+h/kB3Nce2f2g8AtdHRL0GmmMja9L8djNETYTKFqJhXjvqiWpT1ejbZr
   w==;
X-CSE-ConnectionGUID: XJlVYhZbQsaLVj8StH6yMg==
X-CSE-MsgGUID: L7+/6aIeTXG93qXGBcBpYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="93432977"
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="93432977"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 07:19:48 -0700
X-CSE-ConnectionGUID: x7hcFQATTtqryFL3uopCBg==
X-CSE-MsgGUID: +PsV/Lt+TOmvIVh2Oaz8qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="246966132"
Received: from ubuntu.bj.intel.com ([10.238.152.72])
  by fmviesa007.fm.intel.com with ESMTP; 24 Jun 2026 07:19:45 -0700
From: Jun Miao <jun.miao@intel.com>
To: jarkko@kernel.org,
	dave.hansen@linux.intel.com,
	kai.huang@intel.com
Cc: challvy.tee@gmail.com,
	fan.du@intel.com,
	linux-kernel@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	qiang.zhang@linux.dev,
	jun.miao@intel.com
Subject: [PATCH v4] x86/sgx: Fix RCU Tasks stall in EPC sanitization loop
Date: Wed, 24 Jun 2026 22:20:11 +0800
Message-Id: <20260624142011.2965809-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel resets all EPC pages to a clean state in a loop before using them
for enclaves.  The number of EPC pages could be large (e.g., GBs) thus
resetting them could take a fair amount of time.  Because of that, during
early boot, the kernel resets EPC pages through a kernel thread ksgxd() and
there's a cond_resched() after resetting each EPC page.

This is fine in most cases, but becomes a problem when there's other kernel
code waiting for RCU-Tasks grace period but the cond_resched() in ksgxd()
never triggers rescheduling.  Because cond_resched() doesn't report quiescent
state when it doesn't trigger rescheduling, the thread that is waiting for
RCU-Tasks grace period will need to wait until all EPC pages are reset.

For instance, BPF LSM subsystem can invoke synchronize_rcu_tasks() at kernel
boot time.  A VM with a large EPC assigned and have BPF LSM enabled can take
a long time to boot, with a call trace triggered:

    rcu_tasks_wait_gp: rcu_tasks grace period number 1 (since boot) is 130631 jiffies old.
    INFO: task systemd:1 blocked for more than 122 seconds.
    ...
    task:systemd  state:D stack:0  pid:1  tpid:1  ppid:0  flags:0x00000002
    Call Trace:
    ...
    schedule_timeout+0x157/0x170
    wait_for_completion+0x88/0x150
    __wait_rcu_gp+0x17e/0x190
    synchronize_rcu_tasks_generic+0x64/0x60
    ...
    synchronize_rcu_tasks+0x15/0x20
    register_ftrace_direct+0x31f/0x350
    ...
    bpf_trampoline_link_prog+0x33/0x60
    bpf_tracing_prog_attach+0x3c5/0x5f0

Replace cond_resched() with cond_resched_tasks_rcu_qs() which explicitly report quiescent
regardless whether actual rescheduling is triggered.  Resetting all EPC pages in ksgxd()
isn't performance critical so the extra cost of cond_resched_tasks_rcu_qs() isn't a problem.

Tests showed this reduced the VM kernel boot time from ~50s to ~700ms.

Reported-by: Challvy Tee <challvy.tee@gmail.com>
Link: https://github.com/systemd/systemd/issues/40423
Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
Tested-by: Challvy Tee <challvy.tee@gmail.com>
Suggested-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Fan Du <fan.du@intel.com>
Signed-off-by: Fan Du <fan.du@intel.com>
Signed-off-by: Jun Miao <jun.miao@intel.com>

---
v1 -> v2:
 - Clarify the RCU Tasks stall root cause.
 - Use cond_resched_rcu_qs() following the Kai`s suggestion.

v2 -> v3:
 - cee439398933 ("rcu: Rename cond_resched_rcu_qs() to cond_resched_tasks_rcu_qs()")

v3 ->v4:
 - Trim down/rewrite changelog following Kai`s suggestion.

---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4505f808af5e..7ba3d0a5a05d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -106,7 +106,7 @@ static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
 			left_dirty++;
 		}
 
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	list_splice(&dirty, dirty_page_list);
-- 
2.32.0

