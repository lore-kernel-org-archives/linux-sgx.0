Return-Path: <SRS0=s70M=YA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE06ECE58C
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 18:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01463206C2
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 18:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="QxfIyCQz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbfJGSKD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Oct 2019 14:10:03 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43504 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbfJGSKD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 7 Oct 2019 14:10:03 -0400
Received: from zn.tnic (p200300EC2F0642008DAA100DB0709541.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:4200:8daa:100d:b070:9541])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C81311EC05FD;
        Mon,  7 Oct 2019 20:10:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570471802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5cIYqwVqqS8NoWm5xFx9vBQRzZzElKwM5wDEfP3aKZg=;
        b=QxfIyCQzPaQauask7kKASpPDp2DEcVvMcUjfaB6QYWntmSSmHnbOfk5zA6Bf0JGSoHoeQe
        DFdfMbvocA9SWsXYFChNgoDt30xBAcbOfjUu3KgJQY5iPeVNLhIIWwxn4VD6XpyLic3+j4
        Sf64gfDM3WC+7bEmh08PL5q5vWwj2IY=
Date:   Mon, 7 Oct 2019 20:09:55 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 09/24] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20191007180955.GF24289@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-10-jarkko.sakkinen@linux.intel.com>
 <20191005164408.GB25699@zn.tnic>
 <20191007175555.GA5972@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191007175555.GA5972@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 07, 2019 at 08:55:55PM +0300, Jarkko Sakkinen wrote:
> But checkpatch.pl will complain about it...

You should not take checkpatch.pl messages to the letter but always
sanity-check them with common sense. In this particular example,
readability is much more important than some tool measuring line length.

Sure, if you can make the line fit into 80 columns, then fine, but
having to chop it into unreadability just to make some tool happy is
certainly not what the goal should be.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
