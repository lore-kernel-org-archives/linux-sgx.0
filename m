Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A9EC433E0
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Jan 2021 17:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9591922ADF
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Jan 2021 17:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbhAYReB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 25 Jan 2021 12:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730800AbhAYRO4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 25 Jan 2021 12:14:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA4C222B37;
        Mon, 25 Jan 2021 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611594851;
        bh=PPQ7an+6EgtubXXMbkYTcDYL0VPIYPWrOHcwoKbJDsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pUP+sQAzsU2hSQKQZ2Fwiwb/fn5AUy88xDze7oCkU4Vmzh/+u4OIN2siM0uaGr9DR
         jOXrXES5DW+7bkCsEZLB67r1Ig4+op6bWyNWWYBr09OSND9jsntNXlF5CN4HEJNFSi
         VZda9xd0TPWdij8pfuwv6xfxm0RSAgOPiWtXmuyWPYqkLqrH/2qoxcuPaRaim4hl7q
         8iXNlPGBZ9I0VoNePomf63KoA/kcEZc3eC7xZzWw5+FJChhU1MuoVa9sN2UlOtKGfE
         Cl49bBj5NJpe5T1UQpRLOWqnQfd/uTdWNMbu7ZrTtetP8o/fc2ZLP7OCPFeXlQXzDK
         Lf4a93ByPWXtw==
Date:   Mon, 25 Jan 2021 19:14:08 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@suse.de>,
        Jethro Beekman <jethro@fortanix.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/vdso: fix a warning with x32 compiler
Message-ID: <YA78YPVWsE6WNHhd@kernel.org>
References: <alpine.LRH.2.02.2101230548050.21951@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LRH.2.02.2101230548050.21951@file01.intranet.prod.int.rdu2.redhat.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jan 23, 2021 at 05:50:31AM -0500, Mikulas Patocka wrote:
> This patch fixes a warning:
> arch/x86/entry/vdso/vdso2c.h:38:52: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘size_t’ {aka ‘unsigned int’} [-Wformat=]
> when compiling the kernel with x32 compiler.
> 
> The reason for the warning is that in x32 mode, size_t is defined as
> unsigned, not unsigned long.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: 8382c668ce4f ("x86/vdso: Add support for exception fixup in vDSO functions")

So... Why not %zu?

/Jarkko
