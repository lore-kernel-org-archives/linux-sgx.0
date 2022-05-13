Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0131AC433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 13 May 2022 14:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiEMOnr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 May 2022 10:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382758AbiEMOnL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 13 May 2022 10:43:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3AA208234
        for <linux-sgx@vger.kernel.org>; Fri, 13 May 2022 07:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50226B82F64
        for <linux-sgx@vger.kernel.org>; Fri, 13 May 2022 14:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D309C34100;
        Fri, 13 May 2022 14:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652452780;
        bh=3/bEqBEMTHRmbFfWuH1eFrRcdhFRQbYUUtNnfvbpRqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q/64V8MJocBY9GLEua9os76mZCxEyqyQd4VMxCzt7aN38qeFSPGcfh/nWBot0TAb8
         0XYLHc0UJU8Zo48/TtHdNVT3qjNJvJ6n6VkQ/7mQ1r1uXX+M2QabyD404WDOcZQ8kE
         ggwlRbjbrsOcLow5XUjeg1XgeSX9U8Nh/SsmKr7lwLLed+ui0AkJVqfn072PeU1ply
         uMVTjJrld4ifvLzjmwgrud7HrqxT4v61D8dn6ogJyQj6mYLzi4NFITI5/Y0ThIAeDO
         z2F1VhnfEd3xlWfq3Kx1/oF3V1vtk6sV/a64a51aEi/ree+l1bYmkpWK6U7eOqWSi9
         EYPdhxWmLWqlQ==
Date:   Fri, 13 May 2022 17:38:09 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, seanjc@google.com, fan.du@intel.com
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Message-ID: <Yn5tPS0aLXBgHtYT@iki.fi>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
 <YnuQJaM0p7gD5qel@kernel.org>
 <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 12, 2022 at 08:03:30PM +0800, Zhiquan Li wrote:
> 
> On 2022/5/11 18:29, Jarkko Sakkinen wrote:
> > On Tue, May 10, 2022 at 11:16:46AM +0800, Zhiquan Li wrote:
> >> Hi everyone,
> >>
> >> This series contains a few patches to fine grained SGX MCA behavior.
> >>
> >> When VM guest access a SGX EPC page with memory failure, current
> >> behavior will kill the guest, expected only kill the SGX application
> >> inside it.
> >>
> >> To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
> >> information for hypervisor to inject #MC information to guest, which
> >> is helpful in SGX virtualization case.
> >>
> >> However, current SGX data structures are insufficient to track the
> >> EPC pages for vepc, so we introduce a new struct sgx_vepc_page which
> >> can be the owner of EPC pages for vepc and saves the useful info of
> >> EPC pages for vepc, like struct sgx_encl_page.
> >>
> >> Moreover, canonical memory failure collects victim tasks by iterating
> >> all the tasks one by one and use reverse mapping to get victim tasks’
> >> virtual address. This is not necessary for SGX - as one EPC page can
> >> be mapped to ONE enclave only. So, this 1:1 mapping enforcement
> >> allows us to find task virtual address with physical address
> >> directly.
> > 
> > Hmm... An enclave can be shared by multiple processes. The virtual
> > address is the same but there can be variable number of processes
> > having it mapped.
> 
> Thanks for your review, Jarkko.
> You’re right, enclave can be shared.
> 
> Actually, we had discussed this issue internally. Assuming below
> scenario:
> An enclave provides multiple ecalls and services for several tasks. If
> one task invokes an ecall and meets MCE, but the other tasks would not
> use that ecall, shall we kill all the sharing tasks immediately? It looks
> a little abrupt. Maybe it’s better to kill them when they really meet the
> HW poison page.
> Furthermore, once an EPC page has been poisoned, it will not be allocated
> anymore, so it would not be propagated.
> Therefore, we minimized the changes, just fine grained the behavior of
> SIGBUG and kept the other behavior as before.
> 
> Do you think the processes sharing the same enclave need to be killed,
> even they had not touched the EPC page with hardware error?
> Any ideas are welcome.

I do not think the patch set is going to wrong direction. This discussion
was just missing from the cover letter.

BR, Jarkko
