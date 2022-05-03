Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B80C433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  3 May 2022 02:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiECCFZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 2 May 2022 22:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiECCFX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 2 May 2022 22:05:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9B83A739
        for <linux-sgx@vger.kernel.org>; Mon,  2 May 2022 19:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651543311; x=1683079311;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xv9l+KOcxcZWnwA1I6Dw31j7MEPdiDInRLWu7P0jXDs=;
  b=fU7SfzAepldE3QWJpoUYuqV917UaoCvTJAaLrVrpxTmahGWrhbP6N3Kf
   SRQ37UQtF+OsqV5GejUXBF3DnOgKUY/WUZq19YF0dv2fxSSP4ydUqwtMy
   9g7XG/DAABG64WDuQVTiSuhVFgwNrfyybpmUmq3fwfeJjEWI7DgCRV3zz
   HreLQIDyVy/aU8BclBPBjx46ExdAANIIU3tDZulZ89/qZ07vOlEhcJjYQ
   5oWrFxPIH57GKvVFW1MMnYwxG7TtHNM4BkJWlQ7Tk0MJBpB5ZSsjEIvRS
   952Saq8WoT2cOMFSQ4YCPl1GOpjivJs/4bGkahFlKgnHuGJtknLs3VfHd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="249358615"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="249358615"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 19:01:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="583994747"
Received: from chgan-mobl1.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.238])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 19:01:48 -0700
Message-ID: <f3daf5ed7ea2f8f5a8f762c146774ab6146355fd.camel@intel.com>
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
From:   Kai Huang <kai.huang@intel.com>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Date:   Tue, 03 May 2022 14:01:46 +1200
In-Reply-To: <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
         <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
         <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
         <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
         <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
         <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2022-04-28 at 16:49 -0700, Reinette Chatre wrote:
> > 
> > I also looked a little deeper at this transient failure problem.  The
> > ELDU documentation also mentions a possible error code of:
> > 
> >  	SGX_EPC_PAGE_CONFLICT
> > 
> > It *looks* like there can be conflicts on the SECS page as well as the
> > EPC page being explicitly accessed.  Is that a possible problem here?
> 
> I went down this path myself. SGX_EPC_PAGE_CONFLICT is an error code
> supported by newer ELDUC - the ELDU used in current code would indeed
> #GP in this case. The SDM text describing ELDUC as "This leaf function
> behaves like ELDU but with improved conflict handling for oversubscription"
> really does seem relevant to the test that triggers this issue.

This new error code and the new leaf functions with "C" postfix (ELDUC, etc) are
introduced to support VMM oversubscription of EPC.  VMM oversubscription of EPC
runs independently with guest so theoretically when VMM is performing some
operation on EPC in one CPU, guest running in another CPU can touch the EPC
simultaneously.

The new "C" variants are supposed to be used by VMM when it supports VMM
oversubscription of EPC, so that the VMM can a ENCLS instruction error code,
rather than a #GP when this case happens.  At guest side, when ENCLS conflicting
happens, VMM will get a VM-exit so it can be handed by VMM, i.e. by letting the
guest to run the same ENCLS again.

For now the SGX driver doesn't need to use the "C" variant, nor should it expect
the new SGX_EPC_PAGE_CONFLICT error code, because the driver already needs to
serialize those ENCLS leaf functions which can not run concurrently.  I assume
this should apply to SGX2 support too.

-- 
Thanks,
-Kai


