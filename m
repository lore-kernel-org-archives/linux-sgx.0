Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE21C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 00:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244061AbiETAsH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 May 2022 20:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiETAsH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 May 2022 20:48:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7E6131282
        for <linux-sgx@vger.kernel.org>; Thu, 19 May 2022 17:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653007686; x=1684543686;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W68+zqEEKitUJiBfqycHwTI4Vzs54UutEeoP6KNyCBg=;
  b=OYXhwM9qo4CQu7NHFCE2YPV2yx7Zknq5O4lRQZFa0gIE6FprBdnnhe2E
   IIG/dVT6ClnppgMIiBPXnsTiOTn4/Fjzl6xxz4KLeEcEz3CerkQx5PVG9
   yykX/WkZ43qRoJnwYmDCJI2jgm2Epi+NJA6S0aUvEar2cGCaiCOCWw4Pk
   HNyUT9jjtKY1DNulbIsualnEgmX+MjI10aLCJM9DxAWC3binm0oNDlVhB
   rlSqe/D2IPuob/D94rhLmqJRsaKY85RzktyUCa8naWv0nyI304IkX9pyj
   Zp2D1P5LpbscKqcY764oh9yezbzRuyE4kcaheuOCpMyixFHDX+44Co0c9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="252950082"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="252950082"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 17:48:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="598906895"
Received: from pmbonill-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.34.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 17:48:04 -0700
Message-ID: <3be5e00db1f02913139366c32efb892e6eb71292.camel@intel.com>
Subject: Re: [PATCH v2 2/4] x86/sgx: add struct sgx_vepc_page to manage EPC
 pages for vepc
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, seanjc@google.com, fan.du@intel.com
Date:   Fri, 20 May 2022 12:48:01 +1200
In-Reply-To: <Yoa90l89OTQX0NYk@iki.fi>
References: <20220519031137.245767-1-zhiquan1.li@intel.com>
         <Yoa76TmwHPeS7vRG@iki.fi> <Yoa90l89OTQX0NYk@iki.fi>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2022-05-20 at 00:59 +0300, Jarkko Sakkinen wrote:
> > I think this patch set is going taking wrong approach. Instead it would
> > be better just to re-use struct sgx_encl_page.
> > 
> > Things will get out of hands, if we have a struct of each flavor of the
> > same entity.
> > 
> > Additionally, it will take virtualization code a step closer to be
> > feasible for the page reclaimer consumption.
> 
> I have a better idea. Why don't you simply store 'vaddr' to 'owner',
> i.e.
> 
>         epc_page = sgx_alloc_epc_page((void *)addr, false);
> 
> The new struct is useless, or harmful, because it consumes memory.
> SGX_EPC_PAGE_IS_VEPC is there to interpret the meaning of the field
> correctly.

This is also fine to me.


-- 
Thanks,
-Kai


