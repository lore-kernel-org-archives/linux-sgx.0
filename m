Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81887C433FE
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Oct 2022 20:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJWUjP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Oct 2022 16:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJWUjO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 23 Oct 2022 16:39:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4255467157
        for <linux-sgx@vger.kernel.org>; Sun, 23 Oct 2022 13:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 982A0CE0F28
        for <linux-sgx@vger.kernel.org>; Sun, 23 Oct 2022 20:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B0CC433C1;
        Sun, 23 Oct 2022 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666557550;
        bh=sHhgHJ2iuNI/MqpuKqIY5BwJW5zRoqI75Jmv1Fclsbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pw51CekzHokzu9HlyV3t2Kn2VhZHLjufSdOaXztPOarHS0mo/is7pJUpfyUReQ3Kq
         6hAl3LAikpdzjICTHzPlxzj/WnbG8J0VFt/4eY7YTelXZqKyzUyKTgOOd/fi5QFXHe
         dW1vTnmhpnZ5i896ABU+nT+SCuY1N/ANDqLI2pe6y6F5SgDW1Q44cybrt/9zvW7DCI
         pW7UC+0zTZYxPgrYRD6IwUlvg9JdfdLJGAsCOdbnl8dWmLI1DxkUo3kg/DqRRfsUe8
         Ls9u+RBj1x/bqxviw/ItDEpVQFkz906XxBCI0XpWYcRLgi5pmEUg9Au/g5SEGh/CZU
         u1Ab6cpluFVrQ==
Date:   Sun, 23 Oct 2022 23:39:02 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Message-ID: <Y1WmZgqIkl8GkR/i@kernel.org>
References: <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
 <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
 <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
 <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
 <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 19, 2022 at 10:59:20AM +0000, Huang, Kai wrote:
> static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>                             struct vm_area_struct *vma, unsigned long addr)
> {
> 	......
>         /* Calculate index of EPC page in virtual EPC's page_array */
>         index = vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
> 
>         epc_page = xa_load(&vepc->page_array, index);
>         if (epc_page)
>                 return 0;
> 
> 	...
> }
> 
> As you can see if the EPC page has already been populated at a given index of
> one virtual EPC instance, the current fault handler just assumes the mapping is
> already there and returns success immediately.  This causes a bug when one
> virtual EPC instance is shared by multi processes via fork(): if the EPC page at
> one index is already populated by the parent process, when the child accesses
> the same page using different virtual address, the fault handler just returns
> success w/o actually setting up the mapping for the child, resulting in endless
> page fault.
> 
> This needs to be fixed in no matter what way.

I think you mean that vm_insert_pfn() does not happen for child because
of early return? I did not understand the part about "different virtual
addresses", as it is the same mapping.

R, Jarkko
