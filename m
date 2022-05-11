Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3113C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 22:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348422AbiEKWAK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 18:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348421AbiEKWAJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 18:00:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD576B668
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 15:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652306404; x=1683842404;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BqYNRW+kT/XtWBj7bxmjaj/FDluZ98U2ySbiSlXLKYY=;
  b=YdhN3Pq+l3sQU/U9CtTQ1xUvl7GgRFMlRpXnZqskK7Q2+eDByC5pLJcW
   Lk13sOBHQTu7s6K8fQO9EybjVqTPrwX+jTktrdAyw72OdL/LnQJv5GetV
   ENlrMvKVLDYbz8xNN1ULr2VZGv35IO1Bqd48lZsRlwGa0Kn81Ua8Qa5RZ
   Gz+FLcpYZN8jOaL0clLSzI0WTZCL7X3sHXgbFv9WxllxaWHvOoEN6Ww6s
   F8/9sowE/doBBuGf65gdCQK4eBaiDLyK5cZwDIFy/eyD3p3IMtsdqKNVC
   opGpMEDNNx3awTrKirO5/wfmOyxwRzAUhGVSHNHhM/8C3P7KGYSjM9jT/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="269955579"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="269955579"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 15:00:04 -0700
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="572263433"
Received: from destipon-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.1.148])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 15:00:02 -0700
Message-ID: <9d5ba82536b5dc49eeb8ab2f18a7b393eaed81fa.camel@intel.com>
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
From:   Kai Huang <kai.huang@intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Date:   Thu, 12 May 2022 10:00:01 +1200
In-Reply-To: <op.1l0ob9jbwjvjmi@hhuan26-mobl1.mshome.net>
References: <cover.1651171455.git.reinette.chatre@intel.com>
         <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
         <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
         <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
         <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
         <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
         <YnarpxzH3cEBo5pL@kernel.org>
         <8d44af4c-798c-4887-def6-595f18f7ac66@intel.com>
         <bb918c317ebb96768365b38f00239013b67ad607.camel@intel.com>
         <YnuPR3OW7xdEXnVF@kernel.org> <op.1l0ob9jbwjvjmi@hhuan26-mobl1.mshome.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> > > > > 
> > > > > This part puzzles me in the pseudo-code.
> > > > > 
> > > > > The version is read first:
> > > > > 
> > > > > TMP_VER := DS:RDX[63:0];
> > > > > 
> > > > > Then there's MAC calculation, comparison,  and finally this check:
> > > > > 
> > > > > (* Check version before committing *)
> > > > > IF (DS:RDX ≠ 0)
> > > > >         THEN #GP(0);
> > > > > ELSE
> > > > >         DS:RDX := TMP_VER;
> > > > > FI;
> > > > > 
> > > > > For me it is a mystery what does zero the slot and in what condition
> > > > > it would be non-zero. Perhaps the #GP refers anyway to this check?
> > > > 
> 
> 
> We discussed this internally, and agree this part of pseudo code needs be  
> corrected/clarified.
> 
> Here is what we think was going on when ELDU invoked with PCMD of all  
> zeros: ELDU would check if the PCMD.SECINFO.FLAGS.PT is 0 which indicates  
> that the page being loaded is a PT_SECS, and the PAGEINFO.SECS is not  
> zero, then the instruction will #GP(0).  Thus, ELDU is behaving correctly  
> – it is an omission in the SDM pseudocode.
> 
> The version checking code above also need be clarified because the VA slot  
> would be cleared at this point and TMP_VER should be zero.

"VA slot would be cleared at this point" isn't accurate.  The VA slot itself is
still occupied at this point.  The original TMP_VER before the decryption is the
VA slot value stored by EWB, and after decryption it becomes 0, if the
decryption is correct.  The correct pseudo-code should be:

	IF (TMP_VER != 0)
		THEN #GP(0);
	ELSE
		DS:RDX	= TMP_VER;
	FI;

The check of TMP_VER against 0 is just an additional safe guard to make sure
decryption didn't fail.


-- 
Thanks,
-Kai


