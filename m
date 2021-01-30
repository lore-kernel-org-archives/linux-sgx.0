Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490CEC433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Jan 2021 13:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12F2564E0C
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Jan 2021 13:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhA3NZp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 30 Jan 2021 08:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230358AbhA3NZf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 30 Jan 2021 08:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F043964E0C;
        Sat, 30 Jan 2021 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612013094;
        bh=hjOeJF0UtC1CgUDzbmS2i8NlMtkXI0aQFoL/ziEipGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EU4y5H8A9l4i1QZ3xEVRTZ499W++Ttsx7AqM8hUz8JEzyWqnUmVPz5EXkrtZfRFDQ
         fObF/tqMwS+Hw2HINuyx9m4siIs5eQAXgoLfA3UCyqtasbIZiJAHJAkz0PqhFwmfWs
         lP7wwGQfbRehdytrWWZia9cFQAhIfncSijXSysK6PoHjz3qCmTptvrudIVnvgeMqQ5
         j3T4DVXzforbWw2odT/EF/JCggLenraETkhzTmoxtYtXFtXqb2xsWbQekfqZ2vEKuC
         XjnWIMFKgVrTVJc6qhhcuCxg++0/gzj8zLrQuKwdVaimTGKZz+I0ukaGzlARvx4jNc
         vG1W0ukjgzO1g==
Date:   Sat, 30 Jan 2021 15:24:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH v3 2/5] x86/sgx: Optimize the locking range in
 sgx_sanitize_section()
Message-ID: <YBVeIb+o2VGzEurU@kernel.org>
References: <20210124062907.88229-1-tianjia.zhang@linux.alibaba.com>
 <20210124062907.88229-3-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124062907.88229-3-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jan 24, 2021 at 02:29:04PM +0800, Tianjia Zhang wrote:
> The spin lock of sgx_epc_section only locks the page_list. The
> EREMOVE operation and init_laundry_list is not necessary in the
> protection range of the spin lock. This patch reduces the lock
> range of the spin lock in the function sgx_sanitize_section()
> and only protects the operation of the page_list.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

I prefer to use the word "optimize" only if there is supporting
data to show that the code change has significant value.

/Jarkko
