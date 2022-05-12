Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CA6C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 14:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354748AbiELOJJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 May 2022 10:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiELOJI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 12 May 2022 10:09:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AACF1FB2FD
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 07:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 057DA61B65
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 14:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADE7C385B8;
        Thu, 12 May 2022 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652364546;
        bh=tXNr319FGDn7sqK8FzoFGluJvwFmkuifsH+PEkG6dA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZTOV1OlrFVBh2DWlRQzZokIJyJCanyOvRVf6u1UKs5c1Xp1lI0WA3NxkQRZfHCwHS
         X+fM7aXQAOu/vWKZJkw7I7yLRGrc4AfHmBJxeM/ODNKEjND06EFC1RENV3frCzwEyu
         f2oj0OSwxypNYYabjdnZfYuCrRBDUq/pLdQfEsUB4dkp1UiAnHSJDYfh73vUeP9p8o
         u4hN5C+dum1ZYcM7l8UckvkWmiaZxRtTkh5QBJ/Kav3oWc2eWAZlU/Z+HkAroRbtaJ
         ylyO8uumeVn3H8bR90UN/fQ0yB53ZBdvXrquCa63a9vVrGgGapzuPEYBHWGTls5bca
         7q9imMu3ijWuA==
Date:   Thu, 12 May 2022 17:10:43 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, haitao.huang@intel.com
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Message-ID: <Yn0VY/tKNIDLx6G0@iki.fi>
References: <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
 <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
 <Ynavabraw26HwnfW@kernel.org>
 <Ynaw2A0z6mBLU0m4@kernel.org>
 <c75f56b5-e071-fe37-835e-7cdd275852f5@intel.com>
 <YnrnBIavYD8yA3Jx@kernel.org>
 <ef9027ad-bf98-2137-992f-0a88246b8cd7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef9027ad-bf98-2137-992f-0a88246b8cd7@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 11, 2022 at 10:23:29AM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 5/10/2022 3:28 PM, Jarkko Sakkinen wrote:
> > Let's just say that I came a bit late to the series, and should have read
> > the whole thread before responding to anything. As long as enclave lock is
> > kept on both sides things should be fine.
> 
> For the most part, yes. The remaining scenario is the case when the reclaimer
> releases the enclave mutex while keeping a reference to the backing store pages.
> By releasing the enclave mutex there is opportunity for page fault
> handler to run and also operate on the backing store. Both the reclaimer
> (after patch 3/4 in this series) and page fault handler operate on
> the backing store with enclave mutex held but if that is done without
> taking backing store references into account data could be lost. This is
> addressed in the following series with:
> https://lore.kernel.org/linux-sgx/d0ace4a1770ab8f4196bfeae06d0970ddb14ef01.1652131695.git.reinette.chatre@intel.com/

Right, I get it now. Great job figuring all this out!

> > 
> > I think for bugs like these it would make sense to put them out early as
> > possible, e.g. I would be fine getting them from kernel bugzilla. Now there
> > there was two week latency on finding the issue, and making it public.
> > Unless there is something confidential, it would be best to get early
> > alert. I'm always ready to change my priorities to help to fix such issues.
> 
> I am sorry about this. The reason I first struggled with this by myself was
> because it was made out to be an SGX2 issue. This was made worse when I was not
> able to create an SGX1 test case that can trigger the issue. I thus lacked
> evidence that it is an upstream issue and it took me a while to debug and
> understand the issue to gain confidence that it is indeed an upstream issue.

No worries, just making the crash log available early on gives a chance
to investigate it :-) We can then figure out whether it is SGX2 issue or
not, or any other circumstance. There should be a low-barrier to do this.

E.g. I happened to get sick when the series was posted, and therefore
lagged on investigation. Giving the maximum amount of window here is super
important.

> Reinette

BR, Jarkko
