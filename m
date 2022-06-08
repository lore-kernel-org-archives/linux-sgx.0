Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394ADCCA47B
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiFHGBG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240937AbiFHFxM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 01:53:12 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C91941F6C8
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 20:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654660372; x=1686196372;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XYGPNza4wdsmn5GjYCy6Y/KRa7x5wUy72ffyNJS7Rt8=;
  b=QC7vvlJyKNOtmqYLMNPSP03o8Kfux25WLGa7Ja8AocTKyh7vKu/jSlDH
   43Xfn3Wz0mzqTYV4DRPAegsvJWhM0Klx5KFAhBtgbkX45B3Rdwd8Uiphz
   Gq//NgcAipM4/quf6W8H1Mfl7WvzzIXx2FM9BHqleHy0ganTz73K+wZMf
   UJ4ebkea4pxuZOpuLtJlvQssFPkDlKfSZS21fDI5n1RJz4hBUOv+2XgtL
   HE7P5fnQVN7V3p37bfq7pkG02qbA5FQwH+/o7dIPk7M9TP7kFzoBpMMYh
   /jGCBud5Bcta7bXzrD4Dm8DkyKCn5iBV6UuaKJ7j7GL2p9YWdhfoqo8+h
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="259881457"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="259881457"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 20:52:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="532924906"
Received: from pkakkine-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.149])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 20:52:48 -0700
Message-ID: <4d0ff55937942835d45d629e4f53597a4b893c0a.camel@intel.com>
Subject: Re: [PATCH v4 2/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
From:   Kai Huang <kai.huang@intel.com>
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com
Date:   Wed, 08 Jun 2022 15:52:46 +1200
In-Reply-To: <20220608032654.1764936-3-zhiquan1.li@intel.com>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
         <20220608032654.1764936-3-zhiquan1.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2022-06-08 at 11:26 +0800, Zhiquan Li wrote:
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -715,6 +715,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
>  	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
>  	struct sgx_epc_section *section;
>  	struct sgx_numa_node *node;
> +	int ret = 0;
> +	unsigned long vaddr;

Please switch the order of the two variables so all of variables are in reverse
Christmas style.

-- 
Thanks,
-Kai


