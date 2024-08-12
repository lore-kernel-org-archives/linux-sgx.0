Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FCE16A95A;
	Mon, 12 Aug 2024 08:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723451641; cv=none; b=KLoNBTG+pfqQi3tFmmWqT8qZ96bNBoPO14GrKrZCNNYyIKs96IvwNJoYPBXtY6vcgUJ+S+JUhDPlX3F5nNeGBfosA+JHr8AvdIY1YlKMo+85/8ne0NRxfLynQ86ue67MfPe22SUiHScoTPQHZoq4sk0QxfUXHd4Kqh4AcBAQynk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723451641; c=relaxed/simple;
	bh=pG6wDFyUJxC3AasONzPAws4KS4sgzPKO6TKJ/wpSuUo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=smvIhahY/dtVIgxqCVQTS27Lg+9m453BAhssveixDvlMIC4mHUU1FbTRoAPSCJJb7SdgYkOb9Lnv5b4StEB+k0pnd6OTOTBp8Rjh3PTwGdSrka+2y1HYEiVVN+BogVxPnIpcBh4jcAbFjVVxQ27kSAeK7rHxw/sK81bZ8dweILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fvvYa48K; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fvvYa48K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723451640; x=1754987640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pG6wDFyUJxC3AasONzPAws4KS4sgzPKO6TKJ/wpSuUo=;
  b=fvvYa48K5rY9WuxSPhimyFcHoS6XuJOEeNkWwe6MQctN023yGKJKDcW2
   Tpy8TaX6UQGz1VlWGZXRxvzjhyvjs8iXdIRAXqxwIYbl7wlW7r1+WomoY
   3bWq/pamETVR9raYlMfijiZdkXCjDwX8dpCN98CpJsx1a/Qk5wATbuyJP
   k/Gx8ZyWRXNNiWG0QglIb7HrcHnDy30VljIGyuwkaL330lX4pryMghRIC
   TiqcdTiCwcRgUVjwFnZBziMRo7fXW/NsuXNwSQ0r/PtX4JM8+nEvL6t5N
   d4omJrzc8DgoCMCFC9DgJAxjrdPHrZiQcZeOGdCsE0K7MUjnglwoa4ueO
   g==;
X-CSE-ConnectionGUID: 2+G1gPcMQ/+CdOAdjfgyPw==
X-CSE-MsgGUID: 4sGuEyO6TbGtRSZ5a6Qb9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="21719371"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="21719371"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:33:58 -0700
X-CSE-ConnectionGUID: RyPsGtIqSZW6Q/9t8j8MLA==
X-CSE-MsgGUID: ipb3PWfLT32bD+AwUolfDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="58144324"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:33:57 -0700
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
	reinette.chatre@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data race
Date: Mon, 12 Aug 2024 01:25:43 -0700
Message-Id: <20240812082543.3119659-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <D2RQZSM3MMVN.8DFKF3GGGTWE@kernel.org>
References: <D2RQZSM3MMVN.8DFKF3GGGTWE@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

On Wed, Jul 17, 2024 at 01:38:59PM +0300, Jarkko Sakkinen wrote:

> Ditto.

Just to be sure: I assume this means "Fixes should be in the head of the
series so please reorder"? If yes, please see my reply in the other email
[1].

[1] https://lore.kernel.org/all/20240812082128.3084051-1-dmitrii.kuvaiskii@intel.com/

--
Dmitrii Kuvaiskii
