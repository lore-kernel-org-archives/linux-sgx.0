Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2300C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  4 May 2022 23:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbiEDXcW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 May 2022 19:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385609AbiEDXJF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 4 May 2022 19:09:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54122CE1F
        for <linux-sgx@vger.kernel.org>; Wed,  4 May 2022 16:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651705498; x=1683241498;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FoWKHDyM211xf+u1YhI3rKP426kimrf03rOrOENjEJw=;
  b=IkmE+zRChzwyXcjxucpAYkxfCppix/wIxHDAYDhroTT71//ekqWi82MN
   NY9j7/qTy3vYBf+4GVqZP1vwFSW9AR9fonDvFDrWKgr3WkxWv99Qv7ES1
   LwNivGwD3K2SSrUdSUBkP2mkX40r7mleB2ELTDUUfQ/YwnCI+i2qpTtQe
   ZbJM1sv0lDek1kpU5dG3sxSS7iwPSZtGkq5LKJLE6GKAkuwEgMVaADutk
   +Yi84Y8XILqdHltf4UsJBc/OnY1vL4mZJBs0OVORpjHLrz+tSoX3kcFYQ
   oAZihDBeS7VvSxV56fRs5HwA6Wa88W+ART1J+XtY54lhQGNbn1nTRzUiw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="328464410"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="328464410"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 16:04:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="562951671"
Received: from jrhamric-mobl.amr.corp.intel.com (HELO [10.212.121.177]) ([10.212.121.177])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 16:04:56 -0700
Message-ID: <f0d00588-08ea-2a0d-9436-0885fbce22a3@intel.com>
Date:   Wed, 4 May 2022 16:05:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
 <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
 <d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/4/22 15:13, Reinette Chatre wrote:
> -	if (pcmd_page_empty) {
> +	if (pcmd_page_empty && !pcmd_page_in_use(encl, pcmd_first_page)) {
>  		ida_free(&encl->pcmd_in_backing, PFN_DOWN(page_pcmd_off));
>  		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
>  	}

One other thing.  The role of encl->lock here is very important.
Without it, two concurrent page faults could do their individual
memset(), each see !pcmd_page_empty, then decline to truncate the page.

Also, given the challenges here, I do think we should check the
pcmd_page after truncate to ensure it is still all zero's.
