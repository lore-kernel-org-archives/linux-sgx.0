Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3B2C43334
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Jun 2022 10:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbiFFKkg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbiFFKk3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Jun 2022 06:40:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55682A73D
        for <linux-sgx@vger.kernel.org>; Mon,  6 Jun 2022 03:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654512028; x=1686048028;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3J66Ng6iMSDMZCVk50VYN3Xl2z0x2vqPdpDI6/Yf3jo=;
  b=gbfMviLZOHryy8MVgrsmXwCWMNlCkhBkohShjeWUXP8HRAaojIA8F7q6
   CJgNgSPEBha5VUM9zhg09AMqHKWvNS/FjywqQnZj8c2OE6Pr034vhccGn
   nZmzT6+noOFYQcAc09K0YH33LYHMQ89j208YDBc6ZB4kKceoRbmM85f1r
   aSciYwd75JHiP+z03NrbVPORt2m6ysxE8zA/MQYVJlaopV6VPyK/e6vpk
   HcXtRtPdSaaegCusWOmZqZIzmPF5kpgJpW2wel4lIGimHsUKB6n5FvaUg
   4E3khUpsHh8mG8QfXSa50hrHXCvoKfNWLIcjfLwWtP+Llw7+Xcf2YThog
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="264527213"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="264527213"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:40:28 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="635535281"
Received: from ruihongz-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.39.63])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:40:26 -0700
Message-ID: <ccfc5dacc80454e35b0f13410abc8606832f7517.camel@intel.com>
Subject: Re: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
From:   Kai Huang <kai.huang@intel.com>
To:     "Du, Fan" <fan.du@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>
Date:   Mon, 06 Jun 2022 22:40:24 +1200
In-Reply-To: <MN0PR11MB6181099B27E37C05659A30B199A19@MN0PR11MB6181.namprd11.prod.outlook.com>
References: <20220525100604.760576-1-zhiquan1.li@intel.com>
         <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
         <MN0PR11MB6181099B27E37C05659A30B199A19@MN0PR11MB6181.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2022-06-03 at 13:15 +1200, Du, Fan wrote:
> > 
> > This applies on top of Cathy's series, right? Why not send one
> > series with all 12 patches included?
> > 
> > It makes reviewing easier, and we are well beyond 5.19 timeline
> > for these features.
> 
> Patches from Zhiquan try to improve SGX MCA handling, actually this is a BUG
> being
> discussed with customer with SGX deployment already - SGX VM instance got
> killed
> in case of SGX application inside VM consumed poison EPC pages. Expected
> behavior:
> SGX application get killed only in such scenario.
> 
> Seamless patchset from Catchy is another standalone feature, the design seems
> still under discussion. Combining those two distinct purpose-built patchset
> together
> looks wired.

Right.  Those are two different features and I don't see why they should be sent
out together.

Btw, please also note Cathy's SGX rebootless recovery may never get accepted:

https://lore.kernel.org/linux-sgx/Yo0xSNt0JKGgOG59@zn.tnic/T/#m4d1a56fc3ed547d200443dab50bed6484e6d2e1d
https://lore.kernel.org/all/20220524185324.28395-1-bp@alien8.de/


> 
> Zhiquan's patchset introduced the SGX_EPC_PAGE_IS_VEPC [1] macro to mark guest
> EPC page, luckily Cathy's patchset also has a prior built macro
> SGX_EPC_PAGE_KVM_GUEST
> with same semantics as a simple standalone patch[2].
> 
> For completeness, how about incorporate Cathy's patch[2](keep original
> authorship)
> into Zhiquan up-coming next version(3 patch from Zhiquan, 1 patch from Cathy)?
> Offline synced with Cathy, she is personally ok. while let's see what others
> think about on
> how to prioritize those two things - bugfix and feature enhancement.

Zhiquan's series only needs one flag: SGX_EPC_PAGE_KVM_GUEST.  It doesn't need 
SGX_EPC_PAGE_VA.  I would suggest to just use SGX_EPC_PAGE_KVM_GUEST (if it is
preferred comparing to SGX_EPC_PAGE_IS_VEPC) in Zhiquan's series.


-- 
Thanks,
-Kai


