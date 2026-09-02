Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FE332AABD;
	Wed,  2 Sep 2026 01:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788313032; cv=none; b=XvpyCDF87ZeJHOiY0vFUvZ+vVv/ELg483dVGmtmyGUpiwmLrfj4H68hDGcN5g19RX9LHsz7v4TCcFvt7J846/e25VVvHRRDFqiRqOVu+mWfZJgDX/Dtfjxmog5wJCRDoMvOOADo9NYHIT+80D3MgOwCIDjepooZ/1cXlcYUak+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788313032; c=relaxed/simple;
	bh=PN/RKMQ+kPhwT9ygUPKFcKa36gH6AWVpNeQGmNbdbOQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AjvkkbbuZbp02Ldekn4EYIN/+CmUtBRfF6d8iOzVweXEYcEtWQLETnHxh/E262piqtQY3EeWCMiL7o/sTj653YbfbFhDuCvAhIXnSk2/+F422IL6LoShT+C1XQF90MVgPAdQO/xMR7/rNicy6yYPfqZ2M2SdbbFVrx+bW1zERzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eoY81sTD; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eoY81sTD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788313028; x=1819849028;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PN/RKMQ+kPhwT9ygUPKFcKa36gH6AWVpNeQGmNbdbOQ=;
  b=eoY81sTDNvXWcCZZ8lXDZzNBphUmpztbxdl/0df3iYVgI0+58pILtR38
   Jm+EAove+xIqSDr1tOo1VsV/swddMPaqXaFNtv45+eZS/omgjs6K6YY3/
   oUpdmPeN8kAO0MDvwUxpvVzB8gk5Ta9PtwkLc4H77Qsf9JE0ibjr7oNS7
   9bC2Vfjsc6fcQsrh/8qqgSnZlLymYet4xlpS7YgPi3bGaVhRtvR+GWubW
   UY9BZQiETn5hdqgkv9WLZo7A0ZksPodKND8/C3V0icR4Y23Xo2PXfh+Lw
   bTr47njc2eiuGTWhewcepF2yiBpHY/bxWMpHH+OhmGIvMyYlZynXj++Kd
   A==;
X-CSE-ConnectionGUID: njuIIc0UR2a2U9S7QLOW3A==
X-CSE-MsgGUID: Z0fci8IBShqRPSnLGhcFxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="88884656"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="88884656"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 18:37:04 -0700
X-CSE-ConnectionGUID: wT6x8q+fRSCiUrtlkDWiRA==
X-CSE-MsgGUID: 4MavFmIiS46ctkQQM1syVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="273035798"
Received: from ubuntu.bj.intel.com ([10.238.152.72])
  by orviesa004.jf.intel.com with ESMTP; 01 Sep 2026 18:37:01 -0700
From: Jun Miao <jun.miao@intel.com>
To: dave.hansen@linux.intel.com,
	jarkko@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	kai.huang@intel.com
Cc: linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	fan.du@intel.com,
	challvy.tee@gmail.com,
	jun.miao@intel.com
Subject: [PATCH v7] x86/sgx: Report RCU-Tasks quiescent state in EPC sanitization loop
Date: Wed,  2 Sep 2026 09:36:53 +0800
Message-Id: <20260902013653.690506-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the kernel boots from kexec, the EPC pages may have a stale state.
The kernel sanitizes all EPC pages to reset them to a clean state before
their first use in any enclave.  The EPC size could be several GBs and
resetting them could take a significant amount of time.  Because of that,
the kernel performs the reset in a loop through a kernel thread ksgxd() at
early boot, and there's a cond_resched() after resetting each EPC page.

This is fine in most cases, but becomes a problem when there's other kernel
code waiting for an RCU-Tasks grace period but the cond_resched() in
ksgxd() never triggers rescheduling.  Because cond_resched() doesn't report
a quiescent state when it doesn't trigger rescheduling, the thread that is
waiting for an RCU-Tasks grace period will wait until all EPC pages are
reset.

For instance, BPF LSM subsystem can invoke synchronize_rcu_tasks() at
kernel boot time.  A VM with a large EPC assigned and BPF LSM enabled can
take a long time to boot, with a call trace triggered:

    rcu_tasks_wait_gp: rcu_tasks grace period number 1 (since boot) is
	130631 jiffies old.
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

Replace cond_resched() with cond_resched_tasks_rcu_qs() which explicitly
reports quiescent state regardless of whether actual rescheduling is
triggered.  Resetting all EPC pages in ksgxd() isn't performance critical
so the extra cost of cond_resched_tasks_rcu_qs() isn't a problem.

Tests showed this reduced the VM kernel boot time from ~50s to ~700ms.

Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
Suggested-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Fan Du <fan.du@intel.com>
Signed-off-by: Fan Du <fan.du@intel.com>
Signed-off-by: Jun Miao <jun.miao@intel.com>
Tested-by: Challvy Tee <challvy.tee@gmail.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://github.com/systemd/systemd/issues/40423
---
v1 -> v2:
 - Clarify the RCU Tasks stall root cause.
 - Use cond_resched_rcu_qs() following the Kai`s suggestion.

v2 -> v3:
 - cee439398933 ("rcu: Rename cond_resched_rcu_qs() to cond_resched_tasks_rcu_qs()")

v3 -> v4:
 - Trim down/rewrite changelog following Kai`s suggestion.

v4 -> v5:
 - Change the title, not state the problem directly
 - Corrected spelling and grammatical errors by Kai
 - Add "Reviewed-by: Kai Huang"

v5 -> v6:
 - Add the exactly kind of reminder that why cond_resched() does 
   not trigger rescheduling.

v6 -> v7:
 - Based on Dave's suggestion, add Jarkko's tag:
   Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

---
 arch/x86/kernel/cpu/sgx/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4505f808af5e..207e680732a4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -106,7 +106,13 @@ static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
 			left_dirty++;
 		}

-		cond_resched();
+		/*
+		 * cond_resched() only schedules when TIF_NEED_RESCHED is set.
+		 * During this boot-time loop that condition may not happen for a
+		 * long time, so report an RCU-Tasks quiescent state explicitly.
+		 * Therefore, change cond_resched() to cond_resched_tasks_rcu_qs().
+		 */
+		cond_resched_tasks_rcu_qs();
 	}

 	list_splice(&dirty, dirty_page_list);
-- 
2.43.0

