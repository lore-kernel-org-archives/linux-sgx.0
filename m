Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D7FC433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 10:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiEKK1s (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 06:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiEKK1r (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 06:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ABB48313
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 03:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C8161578
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 10:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86270C340ED;
        Wed, 11 May 2022 10:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652264864;
        bh=ggyE/64rdacnyozTSjJwSrniRBaUM8vayj+zQck2X/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kjaWNDUTlCI2rCsGbp9E9trSoIhr86O41Py8UFFkwIOC3fApQnvLpPzjrINYF2iuA
         hs3s6tlDew2JQNzmqW4TbnArzTAMuaAWTTHjUuk1y8HsZOSZZE/WufukNxC6g+FVkf
         w4hoCCXP5uWyfHFi9lLLhakqGeisO6psSsGXllgJfIlG/bb61OjGH41AFYU3KGHBYz
         SpvB1u0XwohiZPZ4AlXnHaIf8iqfDFQlINR29Lc6elGNyN2cFZ7vnXlwG7jK5xUiWK
         LAqWl1ZpTdwdeMD8CW8ysKcNw9AQk7jj65IwzGf8smEa7Bmc9yk5xZRan7ZDL40+ao
         kKGBRqUWWL5/g==
Date:   Wed, 11 May 2022 13:26:15 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
Message-ID: <YnuPR3OW7xdEXnVF@kernel.org>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
 <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
 <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
 <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
 <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
 <YnarpxzH3cEBo5pL@kernel.org>
 <8d44af4c-798c-4887-def6-595f18f7ac66@intel.com>
 <bb918c317ebb96768365b38f00239013b67ad607.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb918c317ebb96768365b38f00239013b67ad607.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 10, 2022 at 12:36:19PM +1200, Kai Huang wrote:
> On Mon, 2022-05-09 at 10:17 -0700, Reinette Chatre wrote:
> > Hi Jarkko,
> > 
> > On 5/7/2022 10:25 AM, Jarkko Sakkinen wrote:
> > > On Thu, Apr 28, 2022 at 04:49:00PM -0700, Reinette Chatre wrote:
> > > > > I also looked a little deeper at this transient failure problem.  The
> > > > > ELDU documentation also mentions a possible error code of:
> > > > > 
> > > > > 	SGX_EPC_PAGE_CONFLICT
> > > > > 
> > > > > It *looks* like there can be conflicts on the SECS page as well as the
> > > > > EPC page being explicitly accessed.  Is that a possible problem here?
> > > > 
> > > > I went down this path myself. SGX_EPC_PAGE_CONFLICT is an error code
> > > > supported by newer ELDUC - the ELDU used in current code would indeed
> > > > #GP in this case. The SDM text describing ELDUC as "This leaf function
> > > > behaves like ELDU but with improved conflict handling for oversubscription"
> > > > really does seem relevant to the test that triggers this issue.
> > > > 
> > > > I stopped pursuing this because from what I understand if
> > > > SGX_EPC_PAGE_CONFLICT is encountered with commit 08999b2489b4 ("x86/sgx:
> > > > Free backing memory after faulting the enclave page") then it should
> > > > also be encountered without it. The issue is not present with
> > > > 08999b2489b4 ("x86/sgx: Free backing memory after faulting the
> > > > enclave page") removed. I am thus currently investigating based on
> > > > the assumption that the #GP is encountered because of MAC
> > > > verification problem. I may be wrong here also and need more information
> > > > since the SDM documents two seemingly related errors:
> > > > #GP(0) -> If the instruction fails to verify MAC.
> > > > SGX_MAC_COMPARE_FAIL -> If the MAC check fails.
> > > 
> > > This part puzzles me in the pseudo-code.
> > > 
> > > The version is read first:
> > > 
> > > TMP_VER := DS:RDX[63:0]; 
> > > 
> > > Then there's MAC calculation, comparison,  and finally this check:
> > > 
> > > (* Check version before committing *)
> > > IF (DS:RDX ≠ 0) 
> > >         THEN #GP(0); 
> > > ELSE
> > >         DS:RDX := TMP_VER;
> > > FI; 
> > > 
> > > For me it is a mystery what does zero the slot and in what condition
> > > it would be non-zero. Perhaps the #GP refers anyway to this check?
> > 
> > RDX contains the VA slot information and that appears to be correct
> > in these scenarios. The issue is the PCMD data pointed to by the
> > PAGEINFO.PCMD (link to PAGEINFO found in RBX) is all zeroes.
> > 
> > There are two scenarios under which the PCMD data could be zeroes. They
> > are documented in:
> > https://lore.kernel.org/linux-sgx/8157fa40-8d02-8819-e1b6-fd2d8863fb56@intel.com/
> > https://lore.kernel.org/linux-sgx/da387afc-e666-45d0-1e99-066d8c4aab03@intel.com/
> > 
> > I understand that context may be lost by pointing you to various emails
> > in this thread - I'll wrap up all learnings when I submit the new version
> > of this series today.
> > 
> 
> Hi Reinette,
> 
> Regardless the root cause of this problem, I agree with Jarkko above pseudo-code
> in the spec is quite confusing.  I can try to get it clarified from Intel
> internally if you want.
 
It is :-) Yeah, it would be great if it could be made a bit more punctual!

BR, Jarkko
