Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D8B1A23B1;
	Thu,  5 Feb 2026 01:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770256503; cv=none; b=ZdFWjSOS8c3Jsjg2bvkszf63w2WwzbMd+jxhsl0GJ4VeNgVwoWIiw7pMVO9c7oqSG9/BcbJAfIhjdoTGfdgt1Y0XGQ2Y9ftMaur0cBEBZqGhucgTDFseHLoPXhTP46XkK+S11Jis5mE3XjbCk4+qEEO4Vc8pXCWWBre7D+4ytGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770256503; c=relaxed/simple;
	bh=O2VdeZz8AAZjqyjZPFnvlY8VM5fbCRDxKlf3pKH3hLA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=vGF9a/F2OT9mvxZoz29UW/G6sC93zXb55dXZZUnj83CitJDxRDtZFvuSsJ+rWZWnAQB5mZEGTuzLhCx6cbpIKjPhbIpIYMrW9/kt88IyORHtiONrfJzb8opeQxLpaLxMMiPIytpx1AJ8nGd9BLxpOF+pt5K2g1dgjzmtfxC4WhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, "H .
 Peter Anvin" <hpa@zytor.com>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] x86/sgx: Fix SRCU list traversal
Date: Wed, 4 Feb 2026 20:53:57 -0500
Message-ID: <20260205015357.3635-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc2.internal.baidu.com (172.31.50.46) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

Replace list_for_each_entry_rcu() with list_for_each_entry_srcu()
when traversing the encl->mm_list protected by SRCU. This ensures
proper synchronization annotation and avoids potential lockdep
warnings about incorrect RCU usage.

The list is protected by encl->srcu, not RCU, so the SRCU-specific
iterator with srcu_read_lock_held() annotation is required.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 12 ++++++++----
 arch/x86/kernel/cpu/sgx/main.c |  3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index cf149b9..3c488a0 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -822,7 +822,8 @@ static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
 
 	idx = srcu_read_lock(&encl->srcu);
 
-	list_for_each_entry_rcu(tmp, &encl->mm_list, list) {
+	list_for_each_entry_srcu(tmp, &encl->mm_list, list,
+			srcu_read_lock_held(&encl->srcu)) {
 		if (tmp->mm == mm) {
 			encl_mm = tmp;
 			break;
@@ -933,7 +934,8 @@ const cpumask_t *sgx_encl_cpumask(struct sgx_encl *encl)
 
 	idx = srcu_read_lock(&encl->srcu);
 
-	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+	list_for_each_entry_srcu(encl_mm, &encl->mm_list, list,
+			srcu_read_lock_held(&encl->srcu)) {
 		if (!mmget_not_zero(encl_mm->mm))
 			continue;
 
@@ -1018,7 +1020,8 @@ static struct mem_cgroup *sgx_encl_get_mem_cgroup(struct sgx_encl *encl)
 	 */
 	idx = srcu_read_lock(&encl->srcu);
 
-	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+	list_for_each_entry_srcu(encl_mm, &encl->mm_list, list,
+			srcu_read_lock_held(&encl->srcu)) {
 		if (!mmget_not_zero(encl_mm->mm))
 			continue;
 
@@ -1212,7 +1215,8 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
 
 		idx = srcu_read_lock(&encl->srcu);
 
-		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+		list_for_each_entry_srcu(encl_mm, &encl->mm_list, list,
+				srcu_read_lock_held(&encl->srcu)) {
 			if (!mmget_not_zero(encl_mm->mm))
 				continue;
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index dc73194..ead0405 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -120,7 +120,8 @@ static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
 
 	idx = srcu_read_lock(&encl->srcu);
 
-	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+	list_for_each_entry_srcu(encl_mm, &encl->mm_list, list,
+			srcu_read_lock_held(&encl->srcu)) {
 		if (!mmget_not_zero(encl_mm->mm))
 			continue;
 
-- 
2.9.4

