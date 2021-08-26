Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85A4C432BE
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 00:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC81360551
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 00:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhHZAkW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Aug 2021 20:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbhHZAkV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 25 Aug 2021 20:40:21 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09911C061757;
        Wed, 25 Aug 2021 17:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=C0yArHI7YCKOdFeU9MrU43lT26WcYZTK9a+SMxGE7N4=; b=seHL30GOXPqdjT0RBLOtzZhVXk
        Aqyj0cmAYleyAheZlHzcYNdO2/dYiDlkfGwMkmFyp5EVqv0ZvT+3ly/y3gHzK7GWOTZmivM9Le2xB
        vUluDx7jzV1S5FVSZIkteBzqplPkij7kr9nKVTgho1vo31hSqa9uLko+Ms8+wslLJRIwU1/FlO1vM
        rE2jfuQX1QjI03e97r45xnoOX5N1OQeKxdKjzZI5x1z61tY/Xe4hwkouQprmBrET/mN/IzshJsY50
        jcXfuVemhNBhu14B52RFpgpVuPv7cg1DCklbmlBtia+tdrL7t3P3BII90z8RQP2SRJxoM09vVxTtO
        dOyUHtuQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJ3Qb-008o2s-1K; Thu, 26 Aug 2021 00:39:33 +0000
Subject: Re: [PATCH v3 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20210825235234.153013-1-jarkko@kernel.org>
 <20210825235234.153013-2-jarkko@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ba483b7e-19a3-d4d3-56c0-3371a77341cb@infradead.org>
Date:   Wed, 25 Aug 2021 17:39:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210825235234.153013-2-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/25/21 4:52 PM, Jarkko Sakkinen wrote:
> The amount of SGX memory on the system is determined by the BIOS and it
> varies wildly between systems.  It can be from dozens of MB's on desktops
> or VM's, up to many GB's on servers.  Just like for regular memory, it is
> sometimes useful to know the amount of usable SGX memory in the system.
> 
> Add SGX_MemTotal field to /proc/meminfo, which shows the total amount of
> usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
> BIOS, the printout would be:
> 
> SGX_MemTotal:      22528 kB
> 
> It is less than 32 MB because some of the space is reserved for Enclave
> Page Cache Metadata (EPCM), which contains state variables for all the
> pages in the Enclave Page Cache (EPC).  The latter contains the pages,
> which applications can use to create enclaves.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> ---
> v2:
> * Move ifdef fix for sgx_set_attribute() to a separate patch.
> ---
>   Documentation/x86/sgx.rst      | 6 ++++++
>   arch/x86/include/asm/sgx.h     | 2 ++
>   arch/x86/kernel/cpu/sgx/main.c | 7 ++++++-
>   arch/x86/mm/pat/set_memory.c   | 5 +++++
>   4 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> index dd0ac96ff9ef..68ee171e1d8f 100644
> --- a/Documentation/x86/sgx.rst
> +++ b/Documentation/x86/sgx.rst
> @@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the host and in guests
>   on the same machine, the user should reserve enough EPC (by taking out
>   total virtual EPC size of all SGX VMs from the physical EPC size) for
>   host SGX applications so they can run with acceptable performance.
> +
> +Supplemental fields for /proc/meminfo
> +=====================================
> +
> +SGX_MemTotal
> +	The total usable SGX protected memory in kilobytes.

Hi,

I would prefer to see this listed in Documentation/filesystems/proc.rst
as an optional field, depending on CONFIG_X86_SGX.
Or at least put a reference in proc.rst to this doc file and its
supplemental fields.

thanks.

-- 
~Randy

