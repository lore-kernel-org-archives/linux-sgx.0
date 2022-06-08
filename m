Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416CEC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 08:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiFHIze (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 04:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiFHIyf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 04:54:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D45A3167E9
        for <linux-sgx@vger.kernel.org>; Wed,  8 Jun 2022 01:15:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4027FB825FE
        for <linux-sgx@vger.kernel.org>; Wed,  8 Jun 2022 08:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A410C341CA;
        Wed,  8 Jun 2022 08:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654676118;
        bh=/079tl1dRnA2SnU4HgDD/H/e8O4WUxniCnYJjhN9Ma8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jTQQpN+70UZpIpVAsZkUtzMuSoEDzVhCl0lLrBz6yPsO1J14RnZzT2OQFKL/6R8l4
         ij0y4+JDg0slbRfkqQXdY7o/L9e+iQvD4z/lP+1pWCjAcGxXuQBypI4INKjov9DzRx
         338TVoyDD6p+J3gOsdcCjey/jsNvSumF5i3Jx0qj6qtyB1f6qFew9R5/5jsJlmAjum
         LcyTXKNBIjKh4yICo18eWuQpf6XksW+myk6+195IUjIA3XhXEFzEzMeF0vPr0Qq3K4
         XT7wIQvzhV7tC/HKqBHpgDlx6gvI21ue1kSi+/DC0eZ6Y3qriuO5DrRcru6wPRqC3R
         fl5LHoyHEYldg==
Date:   Wed, 8 Jun 2022 11:13:21 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, dave.hansen@linux.intel.com,
        seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com
Subject: Re: [PATCH v4 2/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Message-ID: <YqBaIXHTnleGcEJB@iki.fi>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
 <20220608032654.1764936-3-zhiquan1.li@intel.com>
 <4d0ff55937942835d45d629e4f53597a4b893c0a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d0ff55937942835d45d629e4f53597a4b893c0a.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 08, 2022 at 03:52:46PM +1200, Kai Huang wrote:
> On Wed, 2022-06-08 at 11:26 +0800, Zhiquan Li wrote:
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -715,6 +715,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
> >  	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
> >  	struct sgx_epc_section *section;
> >  	struct sgx_numa_node *node;
> > +	int ret = 0;
> > +	unsigned long vaddr;
> 
> Please switch the order of the two variables so all of variables are in reverse
> Christmas style.

Yeah, we prefer that. Is it necessary to initialize ret?

BR, Jarkko
