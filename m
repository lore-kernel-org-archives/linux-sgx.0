Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FEE185A
	for <linux-sgx@vger.kernel.org>; Mon, 25 Dec 2023 08:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-35ff23275b8so15773975ab.2
        for <linux-sgx@vger.kernel.org>; Mon, 25 Dec 2023 00:42:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703493734; x=1704098534;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNpK7gVVocd6D97UNc/uU33LSZEMZP8thvqp4QD621w=;
        b=p97J8T4yJmfdWaXPHNi4vRi058848NxKzGx3tNd8Q+3E2O48J+ZJ7AfVes1zbVIKlL
         5aGfhPILnE9mwebGXEKVlFNBY8ImTh4kv+Lswh7HptlJQYepaJIeY8zQLFz9a6RIlSGs
         6Ob0KMQzTlVWR1nwVvzVPeWfbpVFY5Z7Nvmu5yXaqes4hixKnXMj+Coy4OzJtUxFM/ov
         Lxgk+/fbGOTF9JP8lRjeJ0krocShGTjO6yqm3+FmwpPH77M19eu40ObYQXCxgjwpH2Z7
         B//D/E06z6M1nY1YH99+0uZekZE4QpsZ6oxZaX88SzEhYuRN9kE+/voVuDr2RiXtpxER
         u7kA==
X-Gm-Message-State: AOJu0Yx/1lgU3w995VaJypTTq+YVsuh3GT3UBsn13EqrlfG3frYzLwiV
	0djTYnc0mc/NEX7VP4K6c8TfEvCQP3n+ciIrnfYO0mQxzn19
X-Google-Smtp-Source: AGHT+IG3dYA8NKJcN7EVOtfhsfJebVt6ntLuqWhU4s5iyxWjBECkL6g/8PzJsZReEl/yaZ8GUJMt+8bHRF8dIhO+grGV128vuQw/
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d87:b0:35f:8652:5ce8 with SMTP id
 h7-20020a056e021d8700b0035f86525ce8mr619071ila.4.1703493733927; Mon, 25 Dec
 2023 00:42:13 -0800 (PST)
Date: Mon, 25 Dec 2023 00:42:13 -0800
In-Reply-To: <000000000000ad704b05f8de7e19@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e355bc060d518a7e@google.com>
Subject: Re: [v5.15] WARNING in kvm_arch_vcpu_ioctl_run
From: syzbot <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-lts-bugs@googlegroups.com, 
	tglx@linutronix.de, usama.anjum@collabora.com, vkuznets@redhat.com, 
	wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

This bug is marked as fixed by commit:
KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux 5.15
Dashboard link: https://syzkaller.appspot.com/bug?extid=412c9ae97b4338c5187e

---
[1] I expect the commit to be present in:

1. linux-5.15.y branch of
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
