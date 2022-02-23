Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2EDC433FE
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Feb 2022 15:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242379AbiBWPqc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Feb 2022 10:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbiBWPqb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 23 Feb 2022 10:46:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A77EC1151;
        Wed, 23 Feb 2022 07:46:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC4EF61849;
        Wed, 23 Feb 2022 15:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF4BC340E7;
        Wed, 23 Feb 2022 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645631163;
        bh=5y8GBuKQ8Eu0KbdCimROfrUbByVtDNDNH0UD13FuHhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hg2LUP6Xzp4UdLri5evbkORuqJUfg0B6m8UBZKoDct2qzjZLv5InivSv3xRJDNilK
         oTLsrVECQ34vJWpeuCYJSWzbA6vOuYXwdkX22kU28o14s+tDHYQKi0F4Lv4IK/EuPF
         5oF3LjltFoulBk6wuk80Qjc+vksqZeUBGSpqpnvvzilv4ynDdycFinojz0xqy6Dv4x
         UtmzYJsJt6/ekTv+z+HQfSuSsiGkqB+nWboyaf9O0R2d8fBh0KeJDXXOv/rT+Efz9u
         tdIxVFq9smYfi7axYfU+/eIm1Cyw0psR1C0g5fJH+MEi0/H6HY1LNpzgdy/6jrHfV1
         MDB5fo1yohihw==
Date:   Wed, 23 Feb 2022 16:46:39 +0100
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, seanjc@google.com, kai.huang@intel.com,
        cathy.zhang@intel.com, cedric.xing@intel.com,
        haitao.huang@intel.com, mark.shanahan@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 19/32] x86/sgx: Support adding of pages to an
 initialized enclave
Message-ID: <YhZW38aVILsrK4Jo@iki.fi>
References: <cover.1644274683.git.reinette.chatre@intel.com>
 <fcbde9c3e67289eaff9cd8b34989919629fe823c.1644274683.git.reinette.chatre@intel.com>
 <YhDbGfzGWQ5RtwTU@iki.fi>
 <YhDb/QRYMa4+xsyv@iki.fi>
 <YhKLNqgPNNLS7JyN@iki.fi>
 <80f3d7b9-e3d5-b2c0-7707-710bf6f5081e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80f3d7b9-e3d5-b2c0-7707-710bf6f5081e@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 22, 2022 at 11:19:11AM -0800, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 2/20/2022 10:40 AM, Jarkko Sakkinen wrote:
> ...
>  
> > Do you know if it is possible to do EAUG, EMODPR and the do a single
> > EACCEPT for both? Just looking at pseudo-code, it looked doable but
> > I need to check this.
> > 
> > I.e. EAUG has this
> > 
> > EPCM(DS:RCX).BLOCKED := 0;
> > EPCM(DS:RCX).PENDING := 1;
> > EPCM(DS:RCX).MODIFIED := 0;
> > EPCM(DS:RCX).PR := 0;
> > (* associate the EPCPAGE with the SECS by storing the SECS identifier of DS:TMP_SECS *)
> > Update EPCM(DS:RCX) SECS identifier to reference DS:TMP_SECS identifier;
> > (* Set EPCM valid fields *)
> > EPCM(DS:RCX).VALID := 1;
> > 
> > And EMODPR only checks .VALID.
> 
> After that check there is also:
> IF (EPCM(DS:RCX).PENDING is not 0 or (EPCM(DS:RCX).MODIFIED is not 0) )
>     THEN
>         RFLAGS.ZF := 1;
>         RAX := SGX_PAGE_NOT_MODIFIABLE;
>         GOTO DONE;
> FI;
> 
> Attempting the SGX_IOC_ENCLAVE_RESTRICT_PERMISSIONS ioctl() on a recently
> added page (EAUG) that has not yet been EACCEPTed is thus expected to fail
> with errno of EFAULT (indicating ENCLS[EMODPR] failure) and the returned
> structure's result field set to 20 (SGX_PAGE_NOT_MODIFIABLE).
> 
> I confirmed this behavior by modifying the "augment" kselftest test by adding
> a SGX_IOC_ENCLAVE_RESTRICT_PERMISSIONS call between the new memory access and
> the EACCEPT.

Thank you, also Mark confirmed this.

BR, Jarkko
