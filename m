Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACC5C2BABC
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 09:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 696DD206F7
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 09:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EvaiF4Ks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgDGJFD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:05:03 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39670 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgDGJFD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Apr 2020 05:05:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id i20so2823708ljn.6
        for <linux-sgx@vger.kernel.org>; Tue, 07 Apr 2020 02:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fv9Ca/0gVHbkbL3qMP5/X1aAE/aj9HiBttqZmkgOI9o=;
        b=EvaiF4KsSP8kKy3ZZUVmanlxoo3F1DjC8tHZk6l4yQ7J+a9s0t5ct8+l46wtEYBlZA
         lbpNs2edWaS3mjWDNogJ/wHpJcW8mlMlsR4n6w3uTnzdNR5XD8RYPdQ6166ggvvQLRhn
         eyPp1nJkNLh59NxNSKQrbpul+f/j6TB0aGlWF2PUj74D1tWfqRfufC5K7nvg7bXYMtG2
         EpT2hFtIsNmkX3T9TBG8VeKvocfj1SQCWfVmxTpGaCGxj+7oF61MBksnwEW+svv8TBX5
         J7oTevwiGYImpycq0h9rZd5UITsh+LKD7lG5tzUvsBPQ4evRGWmlJldNRtNDa4aDTBAl
         LcMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fv9Ca/0gVHbkbL3qMP5/X1aAE/aj9HiBttqZmkgOI9o=;
        b=L9b14bz5b6bg2omZHb2dh/fNDV+lL+oOwbeMIdyJQcBViXJXaUwMTfOXQ9y0dNxPN4
         UXSriRfg9JQ58h/VKasXBecq4w02fZ8FIBxkvPKdctV14Dzd62EONA9W6tivoCQtFgQ+
         i6CmNOe7FuNLwQuQ0/bTD9uRbFmWKxs0EuxUXh7mHSRtx21m0kjPDOafazjMMJAqBnJi
         WoG7YQw2YquKCfoeB1oTYfbRhQCs2OdSSCopHov6XGF+GDdKRUtEOGboWDDr9SU51zX7
         d8JekfjKp/A+CAR7TFTXxIPv9QJ2idP+c9Iku1PWmP89io7/jb0wgHV/lsGYy2M1iUN1
         PAVA==
X-Gm-Message-State: AGi0PuYwXYPiQOrKzXfz8A1aZdnw83hSxJ4yxgEhecSLAepu8+sauTUq
        4oiSjBfEdysm+p49hXixMnk=
X-Google-Smtp-Source: APiQypKqd9MfY0vP84Gucf+/xWrr/v9TmEjl2fENSFiyAxtEopqV5yf7ooN9SbkQEHRsETh74706tA==
X-Received: by 2002:a2e:7d10:: with SMTP id y16mr1034116ljc.21.1586250300597;
        Tue, 07 Apr 2020 02:05:00 -0700 (PDT)
Received: from [192.168.1.38] (88-114-211-119.elisa-laajakaista.fi. [88.114.211.119])
        by smtp.gmail.com with ESMTPSA id b21sm14175652ljo.54.2020.04.07.02.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 02:05:00 -0700 (PDT)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <ed382297-1488-1cdc-bd3f-a8a45de6c488@gmail.com>
Date:   Tue, 7 Apr 2020 12:04:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200406212434.GA34134@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Please correct me if I'm wrong, but isn't it the goal of SGX to let a 
(suitably privileged) process designate some of its memory areas as part 
of SGX enclave? If so, why don't you simply add a system call to do so, 
such as

int sgx_mprotect(void *start, size_t length, int prot, u64 sgx_flags);

like existing pkey_mprotect()? Or add a flag PROT_SGX to mprotect() like 
existing PROT_SAO/PROT_SEM?

-Topi

