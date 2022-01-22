Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B331C433FE
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Jan 2022 23:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiAVXl6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 22 Jan 2022 18:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiAVXl6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 22 Jan 2022 18:41:58 -0500
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39CEC06173B
        for <linux-sgx@vger.kernel.org>; Sat, 22 Jan 2022 15:41:57 -0800 (PST)
Received: from localhost (91-154-92-187.elisa-laajakaista.fi [91.154.92.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sakkinen)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id D64651B00124;
        Sun, 23 Jan 2022 01:41:54 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1642894915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NW7vPEp94/YnlGYjg+twp2wU6mCKdvydL4dT0hRUHw8=;
        b=X/NQZ3UX71xNRrFDlTWJzWODDf3bjbnibnR4LFkTNn9jQvkEWcrBRbNgxjpL3t0hAswCdY
        qlI3AiGe+WGAU2BweVHfg1YnuRhfGN0QrO8S+cLI9ug5+fLJZj/fn0Adij7wyI884NPnLb
        oypSSLs1zNIcXb8W0IGkTwaKTrbH1zWUjYIByU0Yz+fGiOu7JeJPEh7SpnM0E94xLoYU6T
        V3EN61rOLa7JDFUNmthCBY5g0qNpPca4ZonEFrEYWUaF2gp/FjQXXVh6pzE8gIbG+F8nzT
        tzulOxDa01W5qs26/nid8YREyDMCSTcs44ahjHzL/jspomrdVFLsQvEFE4Hn6w==
Date:   Sun, 23 Jan 2022 01:41:39 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: Testing 5.17 bugfix material
Message-ID: <YeyWMxWzvpEywbUx@iki.fi>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=sakkinen smtp.mailfrom=jarkko.sakkinen@iki.fi
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1642894915; a=rsa-sha256;
        cv=none;
        b=JbfiVyL0QaBAQsAhoCPHiUs7dOcb2mtyZeOuWs2Ou7afdguqsJv0Gf68Yi2Ws2x2taUMwh
        WBZMQHiBEzfQMe7F3YrBWquhAyODRSyxFvw9eZbmXp9UHUawx2UsuuNA0VvykdirSvDwme
        +afXI+5qLfPf9JqEUDZDcOIeS8+6bAaW1WGopxiFrbirVUoFuxdsiRzjZVbVq+Ni2AK+JM
        3UtOWK3shf/lGBu0BNs06rGDo/76MM1cl0cWEi1rINPEmU6L6gxmuicNfM3chGMnL4ttAP
        ADhMYtV0/lyUh8TJKbTUtj1XIk6V0Z+OfXhUjKjK8e7R8gwPi2tmauuPGBEewg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1642894915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NW7vPEp94/YnlGYjg+twp2wU6mCKdvydL4dT0hRUHw8=;
        b=W8r6qyd7mgCtHVhVeMfIQ4GO9PJn7buYayLALioUDOkl1FFQYHyl/Adhl/iQ0amJvgrZJ2
        WhrgPpXKhX6k2X795+urK5hc+V8q3oQvXQa8yO5rGiBA0JjHaiafI9ls4X0kCMOV/056Jo
        8zwEt4cpOLoVzIC22y1jkAxF5nkvBHCLAQDWeobDh9rrzKdbPxuouNDPyLSUlx9Z12Cup+
        SwpsZWjS6ZH3/p8Ap2j4pVPvmOginofwnKKxYZqHvb6fMSp4p3Cias5VtGB94CoI/s5xSc
        0FRblF9FnHH4dzluyZUqBiINYKDCuz9Q1PRVOYhLwS3NxQBi2eMM/PDS86oTKg==
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 21, 2022 at 11:57:50AM -0800, Dave Hansen wrote:
> Hi Everyone,
> 
> There are a few SGX fixes that have showed up in the last week or so,
> mostly around RAS and fixing the backing storage issues.  Could folks
                ~~~

Remote ATtestation?

> please give this branch a good thrashing?
> 
> > https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=x86/sgx
> 
> I'm planning to send this bunch up to Linus after 5.17-rc1 comes out.
> 
> Kristen, I really dug into the changelogs of your two patches to make it
> more clear that they are bugfix and stable@ material.  I'd appreciate
> some additional eyeballs there.

Thanks for the heads up, this actually fits perfectly my next weeks other
goals.

I'm implementing ECDSA attestation for Enarx next week (i.e. using AESMD).
I was planning to use this branch in any case.

I can combine that with enclaves that trigger backing storage (it can
host arbitarily sized WebAssembly programs). For those changes I'll do
testing both my own hardware (i5-9600KF) and also Icelake Server
(Platinum 8352Y).

If anything comes up, I'll post a fix directly, or if I get stuck I'll
rise up the issues here.

BR, Jarkko
