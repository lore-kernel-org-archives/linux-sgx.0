Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EED2797AC;
	Mon, 18 Aug 2025 07:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755501249; cv=none; b=OE8U91s2lqTtWa7LpZQ8k6mZJi/+URUyKABQbMCFuzQ6p2nPXt/y28nA6ShZiBAI+pNfoWrRMf/Lxyq1vqlYh/wLuyexEHVYEnREm6/mA7JvVAmx6niBCxaY7FE5+lw8ni1oBCuk4USxYtNknC3Uv+UG/Gojp2KtZShisouqd0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755501249; c=relaxed/simple;
	bh=vOJ2GKotCBT/sq8+HRU47E6S57fE3G/dySeV4dTwl84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y35Qw80JauCP4xJO8BEam3M7zIu7I1OuJiEZ1I13eSJ293jYOdRFeXqhAJ4gbg3JS554xcq87Qfr6HUgkLdi+6vUha0E1OOXp3Fz84jYWdKHayVwkplmgBncSnToMqdCITXJ0Dkvo7999nFB9tQ6tS7kKOSW7WCBVDDeVuxUH1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i8zs/TIP; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i8zs/TIP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755501248; x=1787037248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vOJ2GKotCBT/sq8+HRU47E6S57fE3G/dySeV4dTwl84=;
  b=i8zs/TIPdhRaNQN7ZZdo2VlSB5mQKK5YSIajCUT3h8ic3XMpk5NJ/dmh
   b8EawX0jSDpr4clL4/5Ezo4QELrvToWc9EbnPMztFbOnmfUCNg8+aA8lp
   wzYbX5fIgFEfxQfgNpEioWXUvPsV4MKrG+Xd6q+LMBYXrZChZ5ztAneV4
   pUZmhdwq180xcmsPVQOWQ9IatXUzMsXmjMeP92dOfUyASyB+j6sI3ZNYO
   MnZwok8PCU9+nQAl8mWUeXqmVUUxjb30TFzqALNpG7FC9dgM42948cpyY
   S2CLIN9pm00qodu/JMX9yFryJTYe4iUFoSUhj3KGMpkeEdYY3IIaMxXlz
   A==;
X-CSE-ConnectionGUID: Kr2ieCaIQMehbLYlJYGq5A==
X-CSE-MsgGUID: WrIOB6XwSi+BDAVwh7lrxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="68809430"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="68809430"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:14:08 -0700
X-CSE-ConnectionGUID: kbfNj9XkRE28MbyAYqbmAQ==
X-CSE-MsgGUID: Hqj9i+zuSzu6hOtocH/xUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167421532"
Received: from opintica-mobl1 (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.174])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:13:52 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	seanjc@google.com,
	kai.huang@intel.com,
	mingo@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com,
	chongc@google.com,
	erdemaktas@google.com,
	vannapurve@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v15 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Mon, 18 Aug 2025 10:11:23 +0300
Message-ID: <20250818071304.1717183-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250818071304.1717183-1-elena.reshetova@intel.com>
References: <20250818071304.1717183-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

== Background ==

ENCLS[EUPDATESVN] is a new SGX instruction [1] which allows enclave
attestation to include information about updated microcode SVN without a
reboot. Before an EUPDATESVN operation can be successful, all SGX memory
(aka. EPC) must be marked as “unused” in the SGX hardware metadata
(aka.EPCM). This requirement ensures that no compromised enclave can
survive the EUPDATESVN procedure and provides an opportunity to generate
new cryptographic assets.

== Solution ==

Attempt to execute ENCLS[EUPDATESVN] every time the first file descriptor
is obtained via sgx_(vepc_)open(). In the most common case the microcode
SVN is already up-to-date, and the operation succeeds without updating SVN.

Note: while in such cases the underlying crypto assets are regenerated, it
does not affect enclaves' visible keys obtained via EGETKEY instruction.

If it fails with any other error code than SGX_INSUFFICIENT_ENTROPY, this
is considered unexpected and the *open() returns an error. This should not
happen in practice.

On contrary, SGX_INSUFFICIENT_ENTROPY might happen due to a pressure on the
system's DRNG (RDSEED) and therefore the *open() can be safely retried to
allow normal enclave operation.

[1] Runtime Microcode Updates with Intel Software Guard Extensions,
https://cdrdv2.intel.com/v1/dl/getContent/648682

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ffc7b9496218..3eda7e7942e6 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -934,7 +934,7 @@ static int sgx_usage_count;
  * *             entropy in RNG
  * * %-EIO:    - Unexpected error, retries are not advisable
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -992,14 +992,30 @@ static int __maybe_unused sgx_update_svn(void)
 	return -EIO;
 }
 
+/* Mutex to ensure no concurrent EPC accesses during EUPDATESVN */
+static DEFINE_MUTEX(sgx_svn_lock);
+
 int sgx_inc_usage_count(void)
 {
+	int ret;
+
+	guard(mutex)(&sgx_svn_lock);
+
+	if (!sgx_usage_count) {
+		ret = sgx_update_svn();
+		if (ret)
+			return ret;
+	}
+
+	sgx_usage_count++;
+
 	return 0;
 }
 
 void sgx_dec_usage_count(void)
 {
-	return;
+	guard(mutex)(&sgx_svn_lock);
+	sgx_usage_count--;
 }
 
 static int __init sgx_init(void)
-- 
2.45.2

