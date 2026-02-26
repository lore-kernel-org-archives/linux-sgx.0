Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572172A1BF;
	Thu, 26 Feb 2026 01:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772070090; cv=none; b=d4XkAPW19nRm+LizCCKvLH9bs6rkMQOje63nijy6aROe+skC/lbzz1z9SAmH+J9oToxJEotFNPssh/mSnjee3Sbk3rwLJpHVKndrv7pO4cOrTHLh0QlR1CfCMBEaRWBqYmUlJqBsx9d+bZqKlfprTsjA0+pfIAcLdUk0pO048s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772070090; c=relaxed/simple;
	bh=WVyxOVmx26xkKQfhzsr5SPzJju3zLGGtV5+xk/++DPY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e1MFTgkap38yT0rK+b1FzH9E3PrFKrCyNTsGptJz9CF2G8sVEESfXm9/nJTPlwuKqNPHc4+yt0pHAabYfl0qw8RYfegonyJVNT1zocCeAei19fJ4FeSKrOlm8VdR7b961XMBtVm2g0jN5A4kyr6EufDCS5IZ4hfR7llkgO24LqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, "H .
 Peter Anvin" <hpa@zytor.com>, Kai Huang <kai.huang@intel.com>,
	<linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][v2] x86/sgx: Use list_for_each_entry_srcu() for mm_list traversal
Date: Wed, 25 Feb 2026 20:40:14 -0500
Message-ID: <20260226014014.2541-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc4.internal.baidu.com (172.31.3.14) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

In commit 1728ab54b4be ("x86/sgx: Add a page reclaimer") (v5.11),
list_for_each_entry_rcu() was used to traverse the enclave's mm_list.
However, this is incorrect because the list is protected by a Sleepable
RCU (SRCU) lock (encl->srcu).

Since commit 28875945ba98 ("rcu: Add support for consolidated-RCU reader
checking") (v5.4), RCU lockdep checking has become stricter. When
CONFIG_PROVE_RCU is enabled, using the standard list_for_each_entry_rcu()
while only holding an SRCU lock triggers "suspicious RCU usage" false
positive warnings, as it does not recognize SRCU read-side critical
sections.

Fix this by switching to list_for_each_entry_srcu(), which was
introduced specifically for this purpose in commit ae2212a7216b
("rculist: Introduce list/hlist_for_each_entry_srcu() macros") (v5.10).
This correctly associates the traversal with the SRCU lock and
eliminates the lockdep warnings.

Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: Kai Huang <kai.huang@intel.com>
---
Diff with v1: rewrite changelog

 arch/x86/kernel/cpu/sgx/encl.c | 12 ++++++++----
 arch/x86/kernel/cpu/sgx/main.c |  3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ac60ebd..91362d7 100644
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
index 38b7fd2..581e0c4 100644
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

