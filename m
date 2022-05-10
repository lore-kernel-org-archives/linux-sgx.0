Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E7EC433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 00:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiEJAkW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 20:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiEJAkV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 20:40:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B003EBBA
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 17:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652142986; x=1683678986;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W0wBGuJWmTRjxpzJ5rk2zkZ78DP8gARzLTp98aQDd2Y=;
  b=idaP1t4evCIZgyV5VFUTEwdmNJR7mnIkEpvHqOKnA1a7F4NbWV9VqJhR
   T65Kwuv+yP8d9u474EDaKRBblh/ktXcuFczhabfTGl2WqqQclUTRPYoWk
   BGTADm+jsrN/8Iq03YO94CuHXyp5Qbh4xHtzJ+b3XHSYt3aRGN+e2kqlj
   TzzRv9gRx/AL7fVMjkNoqPbyVzlaojyFbKr0LeDIQ78kp8/HIe2HbPuAe
   cl2aPKaAKLsgJnpxxzP6F+A7pl3Ny4bRYNKIkZ8EN+IsZwSa8JDOeKugM
   PBD60zGw6fnEQLyxafTx3+J+mC7ldT+Jo5PHrb2m22n9KIX99nmz2AUrG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="266801542"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="266801542"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 17:36:25 -0700
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="813725051"
Received: from abehrenx-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.1.104])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 17:36:24 -0700
Message-ID: <bb918c317ebb96768365b38f00239013b67ad607.camel@intel.com>
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
From:   Kai Huang <kai.huang@intel.com>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, haitao.huang@intel.com
Date:   Tue, 10 May 2022 12:36:19 +1200
In-Reply-To: <8d44af4c-798c-4887-def6-595f18f7ac66@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
         <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
         <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
         <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
         <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
         <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
         <YnarpxzH3cEBo5pL@kernel.org>
         <8d44af4c-798c-4887-def6-595f18f7ac66@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2022-05-09 at 10:17 -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 5/7/2022 10:25 AM, Jarkko Sakkinen wrote:
> > On Thu, Apr 28, 2022 at 04:49:00PM -0700, Reinette Chatre wrote:
> > > > I also looked a little deeper at this transient failure problem.  The
> > > > ELDU documentation also mentions a possible error code of:
> > > > 
> > > > 	SGX_EPC_PAGE_CONFLICT
> > > > 
> > > > It *looks* like there can be conflicts on the SECS page as well as the
> > > > EPC page being explicitly accessed.  Is that a possible problem here?
> > > 
> > > I went down this path myself. SGX_EPC_PAGE_CONFLICT is an error code
> > > supported by newer ELDUC - the ELDU used in current code would indeed
> > > #GP in this case. The SDM text describing ELDUC as "This leaf function
> > > behaves like ELDU but with improved conflict handling for oversubscription"
> > > really does seem relevant to the test that triggers this issue.
> > > 
> > > I stopped pursuing this because from what I understand if
> > > SGX_EPC_PAGE_CONFLICT is encountered with commit 08999b2489b4 ("x86/sgx:
> > > Free backing memory after faulting the enclave page") then it should
> > > also be encountered without it. The issue is not present with
> > > 08999b2489b4 ("x86/sgx: Free backing memory after faulting the
> > > enclave page") removed. I am thus currently investigating based on
> > > the assumption that the #GP is encountered because of MAC
> > > verification problem. I may be wrong here also and need more information
> > > since the SDM documents two seemingly related errors:
> > > #GP(0) -> If the instruction fails to verify MAC.
> > > SGX_MAC_COMPARE_FAIL -> If the MAC check fails.
> > 
> > This part puzzles me in the pseudo-code.
> > 
> > The version is read first:
> > 
> > TMP_VER := DS:RDX[63:0]; 
> > 
> > Then there's MAC calculation, comparison,  and finally this check:
> > 
> > (* Check version before committing *)
> > IF (DS:RDX ≠ 0) 
> >         THEN #GP(0); 
> > ELSE
> >         DS:RDX := TMP_VER;
> > FI; 
> > 
> > For me it is a mystery what does zero the slot and in what condition
> > it would be non-zero. Perhaps the #GP refers anyway to this check?
> 
> RDX contains the VA slot information and that appears to be correct
> in these scenarios. The issue is the PCMD data pointed to by the
> PAGEINFO.PCMD (link to PAGEINFO found in RBX) is all zeroes.
> 
> There are two scenarios under which the PCMD data could be zeroes. They
> are documented in:
> https://lore.kernel.org/linux-sgx/8157fa40-8d02-8819-e1b6-fd2d8863fb56@intel.com/
> https://lore.kernel.org/linux-sgx/da387afc-e666-45d0-1e99-066d8c4aab03@intel.com/
> 
> I understand that context may be lost by pointing you to various emails
> in this thread - I'll wrap up all learnings when I submit the new version
> of this series today.
> 

Hi Reinette,

Regardless the root cause of this problem, I agree with Jarkko above pseudo-code
in the spec is quite confusing.  I can try to get it clarified from Intel
internally if you want.

-- 
Thanks,
-Kai


