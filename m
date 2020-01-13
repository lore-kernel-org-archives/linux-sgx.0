Return-Path: <SRS0=xaf1=3C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E16EC33CA8
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 08:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6596D207FF
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 08:48:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="FEkNfwb8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgAMIsQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Jan 2020 03:48:16 -0500
Received: from mail.skyhub.de ([5.9.137.197]:50646 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbgAMIsQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 13 Jan 2020 03:48:16 -0500
Received: from zn.tnic (p200300EC2F05D300845C97C8540218FC.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:d300:845c:97c8:5402:18fc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 297931EC068C;
        Mon, 13 Jan 2020 09:48:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1578905294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=kgZT056cXDTrPDMLT3CXRoK/kIdoabTJ9ItwzTVZxWI=;
        b=FEkNfwb87MVdmGDJ81J+Je51ewLtTxc21wCjW79eZS1IAb+bFxMx07g/M3sCHz1VWPqvlI
        wjXM69HweA2khLli9bVkChQVNoCavA3TI8S0m7D8ankHo5FxWD6gJKf1ht4NH7/E8eYJA0
        MHoLZpcgRFARs8ICMit1BuTmoGYRFf4=
Date:   Mon, 13 Jan 2020 09:48:10 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: v25-rc1
Message-ID: <20200113084810.GB13310@zn.tnic>
References: <20200113035918.GA32455@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200113035918.GA32455@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 13, 2020 at 05:59:18AM +0200, Jarkko Sakkinen wrote:
> I tagged v25-rc1:
> 
> * Fix a double-free issue when SGX_IOC_ENCLAVE_ADD_PAGES
>   fails on executing ENCLS[EADD]. The rollback path executed
>   radix_tree_delete() on the same address twice when this happened.
> * Return -EINTR instead of -ERESTARTSYS in SGX_IOC_ENCLAVE_ADD_PAGES when
>   a signal is pending.
> * As requested by Borislav, move the CPUID 0x12 features to their own word
>   in cpufeatures.
> * Sean fixed a bug from sgx_reclaimer_write() where sgx_encl_put_backing()
>   was called with an uninitialized pointer when sgx_encl_get_backing()
>   fails.
> * Migrated /dev/sgx/* to misc. This is future-proof as struct miscdevice
>   has 'groups' for setting up sysfs attributes for the device.
> * Use device_initcall instead of subsys_initcall so that misc_class is
>   initialized before SGX is initialized.
> 
> Before final v25, this patch set needs to reach mainline:
> 
> https://lore.kernel.org/kvm/20191221044513.21680-1-sean.j.christopherson@intel.com

... and I'm still waiting for Paolo to agree on how to merge this.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
