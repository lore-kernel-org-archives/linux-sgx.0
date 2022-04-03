Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C47C433EF
	for <linux-sgx@archiver.kernel.org>; Sun,  3 Apr 2022 23:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376708AbiDCXvK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 3 Apr 2022 19:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356808AbiDCXvK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 3 Apr 2022 19:51:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573795FA2
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 16:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62873B80DBA
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 23:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC378C340ED;
        Sun,  3 Apr 2022 23:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649029752;
        bh=oflNBVO3wJH2LGehWtP0oIGJbpEgoKx7rKf9jqeExGs=;
        h=Date:From:To:Cc:Subject:From;
        b=J+Vtp/gpgd/zH/Hsw/f9K+yAHrlICFxQb7qiBlNev07CUXL9ChkaX0sXsL6mGNnzL
         ADWUA8jlF8gGrhMtTzg885p71O17RJC5NMGV4CUIdSY3sJ5ifKS5RfphF0J33TfkxP
         P1+ecsQXaVgiXtmfQ5lgxW0c2AuNJbXPeji9AgCujcq+p6UCE1KwOkUkgVxfNqv1JL
         uLyn8KpG2szAESnA2Y8TK+xPcV/1OwAC+U0o1eq0DMlmJLKfci5wbv1jsuwfue9z5J
         D576QwIdlgIiqcG7C2qP7arfVte8dF4FLlhYTbKX/WCdyj8zH/ElpDcdeiW0PUrsLU
         9BtjCXnxdFeIA==
Date:   Mon, 4 Apr 2022 02:50:21 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, reinette.chatre@intel.com
Subject: Odd looking #PF fault code
Message-ID: <YkoyvdqIqkaOk8NL@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

I get this when trying to get EAUG-EACCEPTCOPY to run on Enarx and I get:

Unexpected PF: address: 0x007f7fff910000, error code 0x15

I'm using patches from:

https://github.com/rchatre/linux/tree/sgx/sgx2_submitted_v2_plus_rwx

Fault code is in other words PROT|WRITE|USER|RSVD.

According to arch/x86/kernel/fault.c:

	/*
	 * Reserved bits are never expected to be set on
	 * entries in the user portion of the page tables.
	 */
	if (unlikely(error_code & X86_PF_RSVD))
		pgtable_bad(regs, error_code, address);

Any clue how this fault code could emit?

[*] https://github.com/enarx/enarx/pull/1608

BR, Jarkko
