Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480381876;
	Mon, 12 Aug 2024 08:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723451386; cv=none; b=DfPXcwWdM47Q9XTzXFXYf6eIGMuloI+BnolFlyF/fmlmfxh+9ryUrfN75qo3v9+Qm25yYjF/9C6zyooMnBW+Y1ZxHXSaIwqI/wnh5E1e0dHdY+KC7FbxHtkgBki09pp92hnF00KoAU2ezpAOYbHaGaD4WNm1prG4FcZu0gaBUtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723451386; c=relaxed/simple;
	bh=Hq0CswikbYntUWW3RpVEL9DY5BDGI/8A+nfmQ84NF0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SKlbwLVgjixtSEqcywuDxy9Qy34dU/VNfMU4eVyK4P4XLoW2YANF3+KVaYuTgYTBMtk4yuaoqPIVfn1RwMaCESvHP/B+O8kZ9exjOs2PLP/EEmvKqg3pmt3Cew5uo8WoTw3Lm67bcC2L7XWdGBJNaKxPxuhoEh0qyU5FXxvVbUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZZOwXsfi; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZZOwXsfi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723451385; x=1754987385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hq0CswikbYntUWW3RpVEL9DY5BDGI/8A+nfmQ84NF0Y=;
  b=ZZOwXsfiis0fNGJbXPCKcS2TYoHhkK/n6qHneQVabQFeM4Hq2ghaJpvF
   FgAB49YtRm/S3ccQodwqrFTtJ7sYZd65OeDlss8y57B3nop4r3VzXPt6G
   QoCR6ozLQJckKsa2NR/W/kT4Up6rOHeT6szhT2+mWSIVqngSkYX5EzQ6I
   ai7shPNU1qBXzmV4724zzjl1MsVGb6htipDWLt9FeS3clpuyOrCoaiXNg
   73gdgU1LaovATtS80Lq1Dc+ovoqbDqiKP1UHMbUcGQ9N2oKxG2sGq6eur
   L1W2YSu+6S2F+7BroShGO4rt1rpJ8i4wOvzm8h9h7bGLAg+23vhZfG/6y
   A==;
X-CSE-ConnectionGUID: xHjp3z77QYKns4Vpi8jxdw==
X-CSE-MsgGUID: V61rX5nRREux6RG9W6HvSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="21521011"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="21521011"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:29:44 -0700
X-CSE-ConnectionGUID: HtzJ6eyVQ8ycEj3EVLhW/w==
X-CSE-MsgGUID: CkdVM58+QJGMoMLL8r5fXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="57846054"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:29:44 -0700
From: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
To: jarkko@kernel.org
Cc: dave.hansen@linux.intel.com,
	dmitrii.kuvaiskii@intel.com,
	haitao.huang@linux.intel.com,
	kai.huang@intel.com,
	kailun.qin@intel.com,
	linux-kernel@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	mona.vij@intel.com,
	mwk@invisiblethingslab.com,
	reinette.chatre@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 2/3] x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
Date: Mon, 12 Aug 2024 01:21:28 -0700
Message-Id: <20240812082128.3084051-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <D2RQZIG59264.2S8OC7IYWLA0F@kernel.org>
References: <D2RQZIG59264.2S8OC7IYWLA0F@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

On Wed, Jul 17, 2024 at 01:38:37PM +0300, Jarkko Sakkinen wrote:

> Fixes should be in the head of the series so please reorder.

Do you mean that the preparation patch [1] should be applied after the two
bug fixes? This seems to not make sense -- isn't it more correct to first
refactor code, and then to fix in a cleaner way? I thought that was the
point of previous Dave Hansen's comments [2].

[1] https://lore.kernel.org/all/20240705074524.443713-2-dmitrii.kuvaiskii@intel.com/
[2] https://lore.kernel.org/all/1d405428-3847-4862-b146-dd57711c881e@intel.com/

--
Dmitrii Kuvaiskii
