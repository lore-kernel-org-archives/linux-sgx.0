Return-Path: <SRS0=IGRU=D7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02160C4363A
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Oct 2020 11:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36FC21D43
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Oct 2020 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603539616;
	bh=tUkmLVWqS2HVA2spPjKU/aqVSlPgk5/0Geim/RIQddA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0x7PbEbO4PHzTTssLayAl7FoavKKcje1uv84puPqLF2EEVlyFQLjnR1vDLIFMqdWp
	 fDUcNoDmg5T+v4Ge3OLIXwG/aURhsEc3a4HPia4D94/sodRwuDFDctIJNQoIrXqYEk
	 YdQlC+umF8ksnl1yIc7jM6YQXtCwUfSFgehaQObQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759793AbgJXLkQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 24 Oct 2020 07:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759759AbgJXLkQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 24 Oct 2020 07:40:16 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79452C0613CE;
        Sat, 24 Oct 2020 04:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cEaW0P/Q37QkXw0l0MiflWs0S8KrBx1DeB/TsJB3hSI=; b=HCKITNGbekOeJfVv+ZqdunnAjy
        yfjdmn6leqM5SwZMuM9XyI2TLh4la3rzvdcqIA2YwFsVvIxgW0K8mc5Jgl85qxDMQgfTI9Y110YVL
        CVs6YDEYWT/utQgBD3NOJtrAv6mQL5YL8Rr7uMkanVXHEOM+etjCloc8zMM9+XI7SVSXejz9sodNM
        QBqOGYCqerqfkyjoiFyBdf/hdHA/YOUM+laQ6aiSmSmS96gOO1pstWxIiZq7JhUFwwryv2NSN3Chy
        RufnStj9HcWZCGlV2dPByL9cfpzUoWpZSzeX//C1V2CqH8sv5kOuoARHHOtydaRY8gZGa95T6fI5i
        L1vHRkoA==;
Received: from 83-245-197-237.elisa-laajakaista.fi ([83.245.197.237] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <kernel.org@kernel.org>)
        id 1kWHu1-0007fm-Bv; Sat, 24 Oct 2020 14:40:05 +0300
Date:   Sat, 24 Oct 2020 14:40:04 +0300
From:   Jarkko Sakkinen <kernel.org@kernel.org>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 15/24] x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION
Message-ID: <20201024114004.GB29427@kernel.org>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-16-jarkko.sakkinen@linux.intel.com>
 <7bb4ff7b-0778-ad70-1fe0-6e1db284d45a@intel.com>
 <20201023101736.GG168477@linux.intel.com>
 <5dc74a43-d738-3711-6967-59d8264a5ee4@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dc74a43-d738-3711-6967-59d8264a5ee4@fortanix.com>
X-SA-Exim-Connect-IP: 83.245.197.237
X-SA-Exim-Mail-From: kernel.org@kernel.org
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 23, 2020 at 04:23:55PM +0200, Jethro Beekman wrote:
> On 2020-10-23 12:17, Jarkko Sakkinen wrote:
> > On Tue, Oct 20, 2020 at 02:19:26PM -0700, Dave Hansen wrote:
> >> On 10/2/20 9:50 PM, Jarkko Sakkinen wrote:
> >>> + * Failure to explicitly request access to a restricted attribute will cause
> >>> + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
> >>> + * is access to the PROVISION_KEY.
> >>
> >> Could we also justify why access is restricted, please?  Maybe:
> >>
> >> 	Access is restricted because PROVISION_KEY is burned uniquely
> >> 	into each each processor, making it a perfect unique identifier
> >> 	with privacy and fingerprinting implications.
> >>
> >> Are there any other reasons for doing it this way?
> > 
> > AFAIK, if I interperet the SDM correctl, PROVISION_KEY and
> > PROVISION_SEALING_KEY also have random salt added, i.e. they change
> > every boot cycle.
> > 
> > There is "RAND = yes" on those keys in Table 40-64 of Intel SDM volume
> > 3D :-)
> > 
> 
> This is nonsense. The whole point of sealing keys is that they don't
> change every boot. If did they they'd have no value over enclave
> memory. RAND means that the KEYID field from the KEYREQUEST is
> included in the derivation (as noted in the source row of the table
> you looked at).

I just looked that the column name is RAND, the row is called "Provision
key" and the cell has "Yes" in it.

> --
> Jethro Beekman | Fortanix

/Jarkko
