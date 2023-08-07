Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2452C001DB
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Aug 2023 13:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbjHGNtX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Aug 2023 09:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbjHGNtS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Aug 2023 09:49:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503951BCB
        for <linux-sgx@vger.kernel.org>; Mon,  7 Aug 2023 06:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691416147; x=1722952147;
  h=to:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=hC+IPTvzmKoelKTM5cFaFlEVdV4OkdHPliZHisz8hfg=;
  b=oAL1Ll0/hh+2mogOdPpETht9rV/r7Ij1+uLbtPJ9a4OuEn/AGlLP4dn3
   yBLCqqgt/hwUO2mwGOvgYKB3Lc/ZOisW8bmr/C1cnG9k+0ow8mlqf2Z/9
   WYYNy15UcSA2T6lhXmuhBA4OBcS7sBVRLQALeV0Y2wkaUCAYuHq7dgYUc
   gx1QnAixoClZVs1SK8cXA9uDVdOvUooGzFoywWOwMnZuYD7TCe7IAqdAd
   ExMOvAChAhIarxmMgtzdmz3OYTOLljNFAfmXKLI5KtcBI+BrNiKZriKHK
   /PGsX+3HolKUlADtILQvhwg8McBNVHWPLTnhWuXEpvMItolnHbcVzsddd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="368003921"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="368003921"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 06:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="800934495"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="800934495"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.17.61])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 07 Aug 2023 06:49:06 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Shutemov, Kirill" <kirill.shutemov@intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: SGX Memory Reservation on SPR
References: <ce32998f-1d7f-9481-ddb8-961b5d0f6a83@intel.com>
 <op.19a6ljf3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Date:   Mon, 07 Aug 2023 08:49:04 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.19a7b20rwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.19a6ljf3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 07 Aug 2023 08:33:09 -0500, Haitao Huang  
<haitao.huang@linux.intel.com> wrote:

> Hi Dave
> On Fri, 04 Aug 2023 16:06:50 -0500, Dave Hansen <dave.hansen@intel.com>  
> wrote:
>
>> What choices do our end users have about how much EPC RAM to dedicate to
>> SGX on SPR systems?  I assume there's some ability to tweak to tweak it
>> in the BIOS.
>
> On one platform I know, BIOS provides choices from 256M to 256G,  
> doubling at each increment. This should depend on OEM/BIOS and available  
> total RAM configured.
>
Also the sizes configured above is per socket. So for this particular  
system with 2 sockets, total EPC can be configured up to 1024G

BR
Haitao
