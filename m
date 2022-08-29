Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678A9ECAAD2
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Aug 2022 12:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiH2Mbi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Aug 2022 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiH2MbB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Aug 2022 08:31:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA0C1A805
        for <linux-sgx@vger.kernel.org>; Mon, 29 Aug 2022 05:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D210B80F03
        for <linux-sgx@vger.kernel.org>; Mon, 29 Aug 2022 12:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C11C433D7;
        Mon, 29 Aug 2022 12:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661775259;
        bh=wfdy8HdAId7LWPNM8BZFQhQBO44gn7uh1WUqfg3ge58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FWoG3QjVsKUijRihGPM/LDUdBxqpfoT3itdv7gM6fGE9cocRHh49FGJezYlh07iHC
         rjYKjQxzcFhxhIOxMOexd1XXggfxXlNq2rzJNQD0jpo6lweykY9C89pgDQ1SzUXeyt
         J4emsbkIpX2liDc1HIEBYJcoCZQnwOIYBqI5566s4XOSNLwfh5uozYO+trVJr4IPug
         PjbP6B2eXAX/ybUPSx9K5IILj/YEW33rg0ymjDBvB+9hib3gFa2K1v1FFURokqZqav
         PPtpCW+7WVaZhq4V6rchfRjmbSOG+kkhs4AfVwlbj8EO7R3jS+ctHn5L9RFKd1vb9O
         ZGGB5f7odN8Uw==
Date:   Mon, 29 Aug 2022 15:14:10 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
Subject: Re: [PATCH RESEND v6 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Message-ID: <YwytkoKoK2TmXPva@kernel.org>
References: <20220826160503.1576966-1-zhiquan1.li@intel.com>
 <20220826160503.1576966-2-zhiquan1.li@intel.com>
 <Ywrgp+NUuB83ajkO@kernel.org>
 <e95f8dcd-49db-8bfb-90aa-b8074002919d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e95f8dcd-49db-8bfb-90aa-b8074002919d@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 29, 2022 at 09:23:48AM +0800, Zhiquan Li wrote:
> 
> On 2022/8/28 11:27, Jarkko Sakkinen wrote:
> > On Sat, Aug 27, 2022 at 12:05:01AM +0800, Zhiquan Li wrote:
> >> In order to describe the purpose of 'owner' field more exactly,
> >> rename the 'owner' field of struct sgx_epc_page as 'encl_owner',
> >> and update all of references.
> >>
> >> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> > Is this rename really worth of doing? I'd only consider
> > such if there was two 'owner' fields but since there is
> > no name collision, why bother?
> > 
> > Thoughts? Please correct me if I've forgot something
> > essential previously discussed.
> > 
> > BR, Jarkko
> > 
> > 
> 
> Hello Jarkko,
> 
> The field name and union comes from Dave's suggestion:
> 
> https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m2ff4778948cdc9ee65f09672f1d02f8dc467247b
> 
> - If the rename make the thing complicated we can consider drop this patch, it might introduce potential conflict with the SGX patches under reviewing.
> - If you think the union introduced by patch 02 is also unnecessary, then we need to discuss it with Dave.
> 
> Best Regards,
> Zhiquan

"In order to avoid unnecessary casting" might then be a better
way to start the sentence.

BR, Jarkko
