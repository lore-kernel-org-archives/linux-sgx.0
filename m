Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558050;
	b=mFZ+PFVtxCet6dYujSe+0N64k5kuwTrRUpUdvPtRhryvcnPFZDLXBVlH7so2PC30hqrr
	 ukHeVNPCMqtEKXqCgqTY4Ut2PbKh0uAyvDumAVX0N+yqxSAXnUVktaXmuwbND9IIEUnZa
	 F7pd2WrQBw35PZjO+STGSm/gFubVl6MvG61Pfzu1Dg1nCzJCSXyMobi/y666yZYJJB8mn
	 PNQns8BBRZqPelD0pwdUMUYBeboHLGMbVzy9tMsZBrpRhilgBwZPj9jlJppETJasJkRSZ
	 ehUei1/zLB27x6kA9VGgXchHgbue497ltEDwO1PLZtRMcX3O9YPq5wUroW39T88LI5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558050;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4Gp5QAphXPOU9Urmv4w5lLuRS2sQ7D3ObztsA4P01E8=;
	b=gT2SgkQs39aG8cRQV5FbyP2HY5Et5/rcqs8mihiXE7PqoppDEe8XzQuubu2J1eDKO5zl
	 Qa1h54MBpN/OBuU6bJSzCH99CllZqD/v++0ZqDePbRpypF4ZxQNJGlHieEl/OVYq3RZJD
	 OCZosxNXg+cmAx54hBnr8Bmo4nO4tjc1PfQuzLLFXYnzoA4fJWUJK4H7C6ZfDjWVnq+/S
	 tM8stOrWA/mmf4eKLBzYCFQzJsII/rulBSLA8dXGift4E2qs7R8vwaB34Om+/fcVhfCVp
	 NSI4DTKlhsPVGlSDlBaffKMQuIGfLmWjqxuSAkBT8iTprsobj8xDpqaSxG/yRnYygnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZLuvAZKg;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493C6606A337;
	Fri, 13 Nov 2026 08:20:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 493C6606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZLuvAZKg
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794558045; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4Gp5QAphXPOU9Urmv4w5lLuRS2sQ7D3ObztsA4P01E8=;
	b=ZLuvAZKgSIFEOC2LzBDygHQRlofg3GWWb6VszCy+ZvY6bNNszQLCgJNEXyFuawTExbJWN3WXsksoXrwG47oCs737tpsFZI42dwHyFJeTU7HeoE+hKiieAz5WmSLiATYkO2QX7dTGYNfxW8JMsWyGk7HOgCl9MfbAygoC4JzJ/CQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XEeQ124_1794558037;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XEeQ124_1794558037 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 16:20:44 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: bp@alien8.de
Cc: dave.hansen@linux.intel.com,
	jarkko@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	challvy.tee@gmail.com,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH v2] x86/crash: Disable SGX in the kdump kernel
Date: Fri, 13 Nov 2026 16:20:36 +0800
Message-ID: <20261113082036.52175-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <0E3109CB-AE2B-475D-95AF-BD5465748ED9@alien8.de>
References: <20261113035019.3747461-1-xiangzao@linux.alibaba.com> <0E3109CB-AE2B-475D-95AF-BD5465748ED9@alien8.de>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 11/13/26 06:19, Borislav Petkov wrote:
> I don't think you even read my mail.

Sorry, I misunderstood your point - language and my reading
comprehension got in the way.

Based on the v1 review and your feedback, my proposed approach is a
small kdump_disable_features() in the x86 kdump code that checks
is_kdump_kernel() and clears the cap, called from setup_arch() after
parse_early_param().  This keeps the disable in x86 kdump code without
a parameter hook.  Does that work for you?

--
Yuanhe
