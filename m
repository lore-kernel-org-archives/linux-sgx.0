Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFEEC433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  7 May 2022 17:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377456AbiEGR2Q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 7 May 2022 13:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357178AbiEGR2N (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 7 May 2022 13:28:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0252733A0C
        for <linux-sgx@vger.kernel.org>; Sat,  7 May 2022 10:24:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E39361172
        for <linux-sgx@vger.kernel.org>; Sat,  7 May 2022 17:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73373C385A5;
        Sat,  7 May 2022 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651944264;
        bh=91bvYZIS4e3bZjsK7IOfTUXO/4oKe0rOPyr03y9qFn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0s61T8MteQpo05a9SgCAQOna236hgBKiMBKu2XiOk2XQWKvia66WLw7kp+/qi4n+
         feJsFu6oaiBxTLmlQ53XQUONYDNSIZBcD9R/nxyFkUx54dE7cvsO1p8rO56OcJCX6x
         AVjqo/oxnr9QiiRtZYt+9JL0giDxMjgPHsBLvFG5Kwatxs6lXeeD6CEf7L5DUTJC7U
         jwXNralvl4opXcRw4SartzY0tJlWL60SGs2Vlf2Dj/cYhmMLbjcRHy5sY3olM33vEK
         ul6tLTtcHxKwb87Uhs/WPLR/fup9De9Z/BFNGyfBEvlJDxkzOeHjhJWdR9BLAFP3gE
         YHau0pOnFGXfA==
Date:   Sat, 7 May 2022 20:25:59 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, haitao.huang@intel.com
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
Message-ID: <YnarpxzH3cEBo5pL@kernel.org>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
 <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
 <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
 <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
 <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 28, 2022 at 04:49:00PM -0700, Reinette Chatre wrote:
> > I also looked a little deeper at this transient failure problem.  The
> > ELDU documentation also mentions a possible error code of:
> > 
> > 	SGX_EPC_PAGE_CONFLICT
> > 
> > It *looks* like there can be conflicts on the SECS page as well as the
> > EPC page being explicitly accessed.  Is that a possible problem here?
> 
> I went down this path myself. SGX_EPC_PAGE_CONFLICT is an error code
> supported by newer ELDUC - the ELDU used in current code would indeed
> #GP in this case. The SDM text describing ELDUC as "This leaf function
> behaves like ELDU but with improved conflict handling for oversubscription"
> really does seem relevant to the test that triggers this issue.
> 
> I stopped pursuing this because from what I understand if
> SGX_EPC_PAGE_CONFLICT is encountered with commit 08999b2489b4 ("x86/sgx:
> Free backing memory after faulting the enclave page") then it should
> also be encountered without it. The issue is not present with
> 08999b2489b4 ("x86/sgx: Free backing memory after faulting the
> enclave page") removed. I am thus currently investigating based on
> the assumption that the #GP is encountered because of MAC
> verification problem. I may be wrong here also and need more information
> since the SDM documents two seemingly related errors:
> #GP(0) -> If the instruction fails to verify MAC.
> SGX_MAC_COMPARE_FAIL -> If the MAC check fails.

This part puzzles me in the pseudo-code.

The version is read first:

TMP_VER := DS:RDX[63:0]; 

Then there's MAC calculation, comparison,  and finally this check:

(* Check version before committing *)
IF (DS:RDX ≠ 0) 
        THEN #GP(0); 
ELSE
        DS:RDX := TMP_VER;
FI; 

For me it is a mystery what does zero the slot and in what condition
it would be non-zero. Perhaps the #GP refers anyway to this check?

BR, Jarkko
