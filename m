Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84453322DC2
	for <linux-sgx@vger.kernel.org>; Wed, 10 Dec 2025 13:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765371654; cv=none; b=URNpQ6eOGwFmVXyxCqboeltIxOY9pohY+KXdcxFo4A/uFZbltzGkleyHGjGrjXyoJFn+B+CXcKNx7KOAyK/mb+oxHbhi3wn8SEdIIGf90kR5d5wU5yAmDjzk2i+WEaGv81rzfr2cgm32gkPmCV+CZ0RE5ypzokPlX0csE1hUX1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765371654; c=relaxed/simple;
	bh=sTLSzWZpGr0ghfJYAeKWsIk+bkEm+Ko2E/tnq6yoXBs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RJHjyJegLljsnpJnjr+bOcwFXYt40Ot2z/BzknNLs1BR73xq4NoXu8eIQngL5d6eHw1t55hKj1kjCBpo+fcItOJ0C9WQmgIU44kk5qldRcErh7+KS+B79YuKk6EWWG8IdmsS+Ve74UGAvcaaFInzfiAtxRUhTM8GyeMudvVdNzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eAdgbtcL; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eAdgbtcL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765371640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bWOiTd6fPNxFZPmQSoBzBzBbXlhKxM+vxWRevTah60I=;
	b=eAdgbtcL+zovA3HXPI5w5susq7WyXoLDhf5DAFpR70AYQpmu0qq3ugPpXUaiYtzKRQdJey
	Ga8HvwGaaAuK31U8gVdeqqR1V+eT84WJDM0lgw5UqtUwHfwHpOD1xBvbKTyu69TZN3q1zS
	FFNYn7d0TgHfgdR1ev6eZtREsmDm334=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Use goto to remove redundant if check in sgx_encl_init
Date: Wed, 10 Dec 2025 14:00:35 +0100
Message-ID: <20251210130035.545132-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Immediately break out of both loops when 'ret != SGX_UNMASKED_EVENT'
instead of checking for the same condition again in the outer loop.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 9322a9287dc7..c1e9841685e8 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -521,15 +521,10 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 			preempt_enable();
 
-			if (ret == SGX_UNMASKED_EVENT)
-				continue;
-			else
-				break;
+			if (ret != SGX_UNMASKED_EVENT)
+				goto skip_loop;
 		}
 
-		if (ret != SGX_UNMASKED_EVENT)
-			break;
-
 		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
 
 		if (signal_pending(current)) {
@@ -538,6 +533,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 		}
 	}
 
+skip_loop:
 	if (encls_faulted(ret)) {
 		if (encls_failed(ret))
 			ENCLS_WARN(ret, "EINIT");
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

