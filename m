Return-Path: <SRS0=xaf1=3C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D422BC33CA9
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 16:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A65C321569
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 16:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="f0BzgoVl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgAMQH6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Jan 2020 11:07:58 -0500
Received: from mail.skyhub.de ([5.9.137.197]:33830 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgAMQH6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 13 Jan 2020 11:07:58 -0500
Received: from zn.tnic (p200300EC2F05D30061EC8816C59C4425.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:d300:61ec:8816:c59c:4425])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C48411EC0C6D;
        Mon, 13 Jan 2020 17:07:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1578931676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=K0l9787TSx+VqINVPcWv3zGJR95hRYe7WfVXXWUC4K4=;
        b=f0BzgoVlPzZnxP8jZOWRLfYhLKuoHQK0T0UF7slbMGLUsf9n6JAOOfPK3gDAPFNWs+GZo0
        b5RUmrRaqHXr9+Hl/V2nAk8lF0FDCGvTWXOKy87vuwos35NjcUbwzstAFLJ0Xf2DKn+WWQ
        HcXzGSk75K1JsBm5Ch1JV7Z14REjHU8=
Date:   Mon, 13 Jan 2020 17:07:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: v25-rc1
Message-ID: <20200113160748.GJ13310@zn.tnic>
References: <20200113035918.GA32455@linux.intel.com>
 <20200113084810.GB13310@zn.tnic>
 <95fc04cb-c305-2ef1-2449-ecb37796c661@redhat.com>
 <20200113140407.GI13310@zn.tnic>
 <21550b11-3545-387c-f367-051919a1e193@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21550b11-3545-387c-f367-051919a1e193@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 13, 2020 at 04:20:35PM +0100, Paolo Bonzini wrote:
> Put them in too, it's even simpler.

/me brews a fresh coffee and gets crackin'.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
