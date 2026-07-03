Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3225F3859EE;
	Fri,  3 Jul 2026 08:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068459; cv=none; b=AF5vfNhylQpI7xyRtFVQi40BCZAlm3nwdl+XImPeYtJwMCOu7peavsy8Yb9TOphtD4mLo6kMW904kjrov5BoEH3Voa8P7h0UecOZFliLOd4PSud4zi90H3h+OpDkvfrS9BfXUeXP/xVTYc05ioHzcWska4cpUZb6hyHl1N3/zWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068459; c=relaxed/simple;
	bh=SoMHBSOUYGFgfP+NEU70pT3nLxzPVIpeyoJ7QhlfL6A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j0lrOSkJRs51/i7PisPtmNlsGmKIn9KvPIC5tASopuQQ3n840JhIMKiz67LrnSJ2ceTQS+ugE0Nd7K4ceIgxA13WgLcmItkFeVSak5lALlrhRx7ztQrlb8xu2ngJ7wLxZOlBl2ftrY6LjA349ceFb7Kjze4eEF0a/Z4s26XeSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=guGMpHlL; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="guGMpHlL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783068457; x=1814604457;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SoMHBSOUYGFgfP+NEU70pT3nLxzPVIpeyoJ7QhlfL6A=;
  b=guGMpHlLFIkG/2P898ea1XSFqCxLz9aSjRdWPrLE6E4rYGd9aBlqezDj
   uG2nN1OysJ9Dnx5JZv00iB+f+2vtv+LBfqFgQYGOPP/FdG38TnzfZqaxH
   7ChWG0N0Y4DlExHwal6YO42NQOPk0wQs6Wa1p6t1EDGsS/EoZrxrUf3p4
   YNE1XNwCtje6QoxgDfFr8W7+50AesMKqpiC6HEBIwxWjnHDpb3ojebSk1
   UL16Yd6oJCG2RYLDLdp/mAS6ldjRz75Hbe3SfTtS9ZpcKjU60hj/l8eLr
   LSAE0ZHFqYhnuESKSEjiUPcueDgZ7TlAOiKJ8RCbmuTEJxH25Qdml9cOH
   A==;
X-CSE-ConnectionGUID: raOimBg+S9uMZHo7jtO1ng==
X-CSE-MsgGUID: NIPJoL86RhuxOgH1+GPkbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="94179094"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="94179094"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 01:47:37 -0700
X-CSE-ConnectionGUID: I9Yz0pPHSqW/MFYvGiqEjg==
X-CSE-MsgGUID: DMS0CCMqRbGyR2DZ0OwJzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="254980425"
Received: from ubuntu.bj.intel.com ([10.238.152.72])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2026 01:47:34 -0700
From: Jun Miao <jun.miao@intel.com>
To: jarkko@kernel.org,
	dave.hansen@linux.intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	kai.huang@intel.com
Cc: linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	fan.du@intel.com,
	jun.miao@intel.com,
	x86@kernel.org
Subject: [PATCH v5] x86/sgx: Report RCU-Tasks quiescent state in EPC sanitization loop
Date: Fri,  3 Jul 2026 16:48:10 +0800
Message-Id: <20260703084810.145567-1-jun.miao@intel.com>
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

---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4505f808af5e..7d2f57663177 100644
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

