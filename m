Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE23EC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 21:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbiELVMs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 May 2022 17:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbiELVMs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 12 May 2022 17:12:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6FF5DE69
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 14:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD827B827FB
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 21:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC019C34100;
        Thu, 12 May 2022 21:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652389964;
        bh=gvfpgD2xr3iKPZirJgZhheL1S2sZ0L9/hIpA6MsK4tw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oQNrkwxTVdkFVJ0hy/UE1fZGUvKgqTInu17ZXJhxytMOgXbE8IWRNmm3qaIswXvl9
         dVRy6nNRL4Nzh7lo6WK83cdsr4Nl7j9xuPRkbN4WzueiOBEagdO15Qs35zk2q3p3hj
         V2agssD4TbG/ik8vbFdmrYL1HBeDTBb39zN1Nb2ybQij/2W3j70qmLIitqf5aR+AHR
         HgzfP10SEOd/FUt7O0VH2+SP4sA+CBF2eJa1emW20qkeHxdxmpyRreWMyqfCfMB6CN
         FlCpEJy21b+ldNvpVtrBWG3OFm2U4rn1gww3776oUKVHlYorgZJVm0mAmjpF0DQ1DC
         ifeTVBsd4tBqw==
Date:   Fri, 13 May 2022 00:14:22 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
Message-ID: <Yn14rsJxZZG44i/d@iki.fi>
References: <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
 <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
 <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
 <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
 <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
 <YnarpxzH3cEBo5pL@kernel.org>
 <8d44af4c-798c-4887-def6-595f18f7ac66@intel.com>
 <bb918c317ebb96768365b38f00239013b67ad607.camel@intel.com>
 <YnuPR3OW7xdEXnVF@kernel.org>
 <op.1l0ob9jbwjvjmi@hhuan26-mobl1.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.1l0ob9jbwjvjmi@hhuan26-mobl1.mshome.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 11, 2022 at 01:29:59PM -0500, Haitao Huang wrote:
> Hi Jarkko
> 
> On Wed, 11 May 2022 05:26:15 -0500, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
> 
> > On Tue, May 10, 2022 at 12:36:19PM +1200, Kai Huang wrote:
> > > On Mon, 2022-05-09 at 10:17 -0700, Reinette Chatre wrote:
> > > > Hi Jarkko,
> > > >
> > > > On 5/7/2022 10:25 AM, Jarkko Sakkinen wrote:
> > > > > On Thu, Apr 28, 2022 at 04:49:00PM -0700, Reinette Chatre wrote:
> > > > > > > I also looked a little deeper at this transient failure
> > > problem.  The
> > > > > > > ELDU documentation also mentions a possible error code of:
> > > > > > >
> > > > > > > 	SGX_EPC_PAGE_CONFLICT
> > > > > > >
> > > > > > > It *looks* like there can be conflicts on the SECS page as
> > > well as the
> > > > > > > EPC page being explicitly accessed.  Is that a possible
> > > problem here?
> > > > > >
> > > > > > I went down this path myself. SGX_EPC_PAGE_CONFLICT is an
> > > error code
> > > > > > supported by newer ELDUC - the ELDU used in current code would
> > > indeed
> > > > > > #GP in this case. The SDM text describing ELDUC as "This leaf
> > > function
> > > > > > behaves like ELDU but with improved conflict handling for
> > > oversubscription"
> > > > > > really does seem relevant to the test that triggers this issue.
> > > > > >
> > > > > > I stopped pursuing this because from what I understand if
> > > > > > SGX_EPC_PAGE_CONFLICT is encountered with commit 08999b2489b4
> > > ("x86/sgx:
> > > > > > Free backing memory after faulting the enclave page") then it
> > > should
> > > > > > also be encountered without it. The issue is not present with
> > > > > > 08999b2489b4 ("x86/sgx: Free backing memory after faulting the
> > > > > > enclave page") removed. I am thus currently investigating based on
> > > > > > the assumption that the #GP is encountered because of MAC
> > > > > > verification problem. I may be wrong here also and need more
> > > information
> > > > > > since the SDM documents two seemingly related errors:
> > > > > > #GP(0) -> If the instruction fails to verify MAC.
> > > > > > SGX_MAC_COMPARE_FAIL -> If the MAC check fails.
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
> Here is what we think was going on when ELDU invoked with PCMD of all zeros:
> ELDU would check if the PCMD.SECINFO.FLAGS.PT is 0 which indicates that the
> page being loaded is a PT_SECS, and the PAGEINFO.SECS is not zero, then the
> instruction will #GP(0).  Thus, ELDU is behaving correctly – it is an
> omission in the SDM pseudocode.
> 
> The version checking code above also need be clarified because the VA slot
> would be cleared at this point and TMP_VER should be zero.
> 
> We will follow up with the architect once he is back from sabbatical and
> make needed adjustment for SDM.

OK, great to hear, thank you!

BR, Jarkko
